// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateless/stateless.dart';

class _TestInterface {
  late int value;
}

class _TestWidget extends Stateless implements _TestInterface {
  _TestWidget({super.key});

  @override
  void initState() {
    value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Text('$value');
  }

  @override
  void dispose() {}
}

void main() {
  group('Stateless', () {
    late _TestWidget widget;

    setUp(() {
      widget = _TestWidget();
    });

    testWidgets('initializes correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: widget));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('updates state', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: widget));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      widget.value++;
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });
  });
}
