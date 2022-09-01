import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template stateless}
/// A stateless widget that is stateful.
/// {@endtemplate}
abstract class Stateless extends InheritedWidget {
  /// {@macro stateless}
  Stateless({super.key}) : super(child: _StateWidget());

  /// Obtains the nearest [Stateless] of type [T] up its widget tree and
  /// returns it as that type.
  ///
  /// Calling this method is relatively expensive (O(N) in the depth of the
  /// tree).
  static T of<T extends Object>(BuildContext context) {
    InheritedElement? ancestor;
    context.visitAncestorElements((element) {
      if (element is T) {
        ancestor = element as InheritedElement;
        return false;
      }
      return true;
    });

    if (ancestor == null) {
      throw StateError('No ancestor of type $T found in the widget tree.');
    }

    return context.dependOnInheritedElement(ancestor!) as T;
  }

  @override
  InheritedElement createElement() => _StatelessElement(this);

  _StatelessState? get _state => (child as _StateWidget)._state;

  /// The location in the tree where this widget builds.
  BuildContext get context => _state!.context;

  /// Describes the part of the user interface represented by this widget.
  Widget build(BuildContext context);

  /// Called when this object is inserted into the tree.
  @mustCallSuper
  void initState() {}

  /// Called when this object is removed from the tree permanently.
  @mustCallSuper
  void dispose() {}

  /// Called whenever the widget configuration changes.
  ///
  /// If it returns true it will reset the state of the widget.
  bool shouldResetState(covariant Stateless oldWidget) => false;

  @override
  @nonVirtual
  bool updateShouldNotify(Stateless oldWidget) => false;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      return _state![invocation.memberName];
    } else if (invocation.isSetter) {
      return _state![invocation.memberName] = invocation.positionalArguments[0];
    }
    return super.noSuchMethod(invocation);
  }
}

class _StatelessElement extends InheritedElement {
  _StatelessElement(Stateless super.widget);
}

// ignore: the following line :-)
// ignore: must_be_immutable
class _StateWidget extends StatefulWidget {
  _StatelessState? _state;

  @override
  State<_StateWidget> createState() => _StatelessState();
}

class _StatelessState<T extends _StateWidget> extends State<T> {
  late Stateless _parent;
  late _StatelessElement element;

  final Map<String, dynamic> _data = <String, dynamic>{};

  dynamic operator [](Symbol k) => _data[k.name];
  void operator []=(Symbol k, dynamic v) => setState(() => _data[k.name] = v);

  @override
  void initState() {
    super.initState();
    _parent = _findParent(context);
    _initState();
  }

  @override
  Widget build(BuildContext context) {
    element.notifyClients(_parent);
    widget._state = this;
    return _parent.build(context);
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_parent.shouldResetState(oldWidget._state!._parent)) {
      oldWidget._state!._dispose();
      _initState();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parent = _findParent(context);
    widget._state = this;
  }

  void _initState() {
    widget._state = this;
    _parent.initState();
  }

  void _dispose() {
    _parent.dispose();
    widget._state = null;
  }

  Stateless _findParent(BuildContext context) {
    late Stateless ancestor;
    context.visitAncestorElements((element) {
      if (element is _StatelessElement) {
        this.element = element;
        ancestor = element.widget as Stateless;
        return false;
      }
      return true;
    });
    return ancestor;
  }
}

/// Exposes the [observe] method.
extension StatelessObserve on BuildContext {
  /// Obtain a value from the nearest ancestor [Stateless] of type [T].
  T observe<T extends Object>() => Stateless.of<T>(this);
}

extension on Symbol {
  String get name => RegExp(r'Symbol\("([a-zA-Z0-9_]+)([=]?)"\)')
      .firstMatch('$this')!
      .group(1)!;
}
