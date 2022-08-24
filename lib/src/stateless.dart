import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Stateless extends InheritedWidget {
  Stateless({super.key}) : super(child: _StateWidget());

  static T of<T extends Stateless>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<T>() as T;
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

class _StateWidget extends StatefulWidget {
  _StatelessState? _state;

  Stateless get parent {
    _StatelessElement? x;
    _state!.context.visitAncestorElements((v) {
      if (v is _StatelessElement) {
        x = v;
        return true;
      }
      return false;
    });
    return x!.widget as Stateless;
  }

  Widget _buildWithState(BuildContext context, _StatelessState state) {
    _state = state;
    return parent.build(context);
  }

  void _initWithState(_StatelessState state) {
    _state = state;
    return parent.initState();
  }

  void _disposeWithState(_StatelessState state) {
    dispose();
    _state = null;
    return parent.dispose();
  }

  @override
  @nonVirtual
  State<_StateWidget> createState() => _StatelessState();
}

class _StatelessState<T extends _StateWidget> extends State<T> {
  final Map<String, dynamic> _data = <String, dynamic>{};

  dynamic operator [](Symbol k) => _data[k.name];

  void operator []=(Symbol k, dynamic v) => setState(() => _data[k.name] = v);

  @override
  void initState() {
    super.initState();
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
    if (widget.shouldResetState(oldWidget)) {
      oldWidget._disposeWithState(this);
      widget._initWithState(this);
    }
  }

  @override
  Widget build(BuildContext context) => widget._buildWithState(context, this);
}

extension StatelessRead on BuildContext {
  T read<T extends Stateless>() => Stateless.of<T>(this);
}

extension on Symbol {
  String get name => RegExp(r'Symbol\("([a-zA-Z0-9_]+)([=]?)"\)')
      .firstMatch('$this')!
      .group(1)!;
}
