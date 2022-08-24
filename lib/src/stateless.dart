import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class StatelessWidget extends StatefulWidget {
  StatelessWidget({super.key});

  _StatelessState? _state;

  /// Describes the part of the user interface represented by this widget.
  Widget build(BuildContext context);

  /// Called when this object is inserted into the tree.
  void initState() {}

  /// Called when this object is removed from the tree permanently.
  void dispose() {}

  BuildContext get context => _state!.context;

  @override
  @nonVirtual
  State<StatelessWidget> createState() => _StatelessState();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      return _state![invocation.memberName];
    } else if (invocation.isSetter) {
      return _state![invocation.memberName] = invocation.positionalArguments[0];
    }
    return super.noSuchMethod(invocation);
  }

  Widget _buildWithState(BuildContext context, _StatelessState state) {
    _state = state;
    return build(context);
  }

  void _initWithState(_StatelessState state) {
    _state = state;
    return initState();
  }

  void _disposeWithState(_StatelessState state) {
    _state = null;
    return dispose();
  }
}

class _StatelessState<T extends StatelessWidget> extends State<T> {
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
  Widget build(BuildContext context) => widget._buildWithState(context, this);
}

extension on Symbol {
  String get name => RegExp(r'Symbol\("([a-zA-Z0-9_]+)([=]?)"\)')
      .firstMatch('$this')!
      .group(1)!;
}
