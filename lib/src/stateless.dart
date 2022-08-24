import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template stateless}
/// A stateless widget that is stateful.
/// {@endtemplate}
abstract class Stateless extends InheritedWidget {
  /// {@macro stateless}
  Stateless({super.key}) : super(child: _StateWidget());

  /// Obtains the nearest [Stateless] of type [T] up its widget tree and
  /// returns it.
  static T of<T extends Stateless>(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<T>())!;
  }

  @override
  InheritedElement createElement() => _StatelessElement(this);

  _StatelessState? get _state => (child as _StateWidget)._state;

  /// The location in the tree where this widget builds.
  BuildContext get context => _state!.context;

  /// Describes the part of the user interface represented by this widget.
  Widget build(BuildContext context);

  /// Called when this object is inserted into the tree.
  void initState() {}

  /// Called when this object is removed from the tree permanently.
  void dispose() {}

  /// Called whenever the widget configuration changes.
  ///
  /// If it returns true it will reset the state of the widget.
  bool shouldResetState(covariant Stateless oldWidget) => false;

  @override
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

  Widget _buildWithState(BuildContext context, _StatelessState state) {
    _state = state;
    return state._parent.build(context);
  }

  void _initWithState(_StatelessState state) {
    _state = state;
    return state._parent.initState();
  }

  void _disposeWithState(_StatelessState state) {
    state._parent.dispose();
    _state = null;
  }

  @override
  @nonVirtual
  State<_StateWidget> createState() => _StatelessState();
}

class _StatelessState<T extends _StateWidget> extends State<T> {
  late Stateless _parent;

  final Map<String, dynamic> _data = <String, dynamic>{};

  dynamic operator [](Symbol k) => _data[k.name];
  void operator []=(Symbol k, dynamic v) => setState(() => _data[k.name] = v);

  @override
  void initState() {
    super.initState();
    _parent = _findParent(context);
    widget._initWithState(this);
  }

  @override
  void dispose() {
    widget._disposeWithState(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_parent.shouldResetState(oldWidget._state!._parent)) {
      oldWidget._disposeWithState(this);
      widget._initWithState(this);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parent = _findParent(context);
  }

  @override
  Widget build(BuildContext context) => widget._buildWithState(context, this);

  Stateless _findParent(BuildContext context) {
    late Stateless parent;
    context.visitAncestorElements((element) {
      if (element is _StatelessElement) {
        parent = element.widget as Stateless;
        return true;
      }
      return false;
    });
    return parent;
  }
}

/// Exposes the [watch] method.
extension StatelessWatch on BuildContext {
  /// Obtain a value from the nearest ancestor [Stateless] of type [T].
  T watch<T extends Stateless>() => Stateless.of<T>(this);
}

extension on Symbol {
  String get name => RegExp(r'Symbol\("([a-zA-Z0-9_]+)([=]?)"\)')
      .firstMatch('$this')!
      .group(1)!;
}
