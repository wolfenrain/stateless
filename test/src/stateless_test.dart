// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateless/stateless.dart';

class _TestInterface {
  late int value;

  void cantBeCalled() {}
}

class _TestWidget extends Stateless implements _TestInterface {
  @override
  void initState() {
    super.initState();
    value = 0;
  }

  @override
  Widget build(BuildContext context) => _TestNested();
}

class _TestWithReset extends Stateless implements _TestInterface {
  @override
  void initState() {
    super.initState();
    value = 0;
  }

  @override
  bool shouldResetState(_TestWithReset oldWidget) {
    return oldWidget.value != 0;
  }

  @override
  Widget build(BuildContext context) => Text('$value');
}

class _TestNested extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widget = context.observe<_TestWidget>();
    return Text('${widget.value}');
  }
}

void main() {
  group('Stateless', () {
    testWidgets('initializes correctly', (WidgetTester tester) async {
      final widget = _TestWidget();
      await tester.pumpWidget(MaterialApp(home: widget));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);
    });

    testWidgets('updates state', (WidgetTester tester) async {
      final widget = _TestWidget();
      await tester.pumpWidget(MaterialApp(home: widget));

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      widget.value++;
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('exposes a BuildContext once mounted', (tester) async {
      final widget = _TestWidget();
      expect(() => widget.context, throwsA(isA<TypeError>()));

      await tester.pumpWidget(MaterialApp(home: widget));

      expect(widget.context, isNotNull);
    });

    group('when dependencies change', () {
      testWidgets('resets state when shouldResetStage returns true',
          (WidgetTester tester) async {
        final widget1 = _TestWithReset();
        await tester.pumpWidget(MaterialApp(home: widget1));

        widget1.value++;
        await tester.pumpAndSettle();

        final widget2 = _TestWithReset();
        await tester.pumpWidget(MaterialApp(home: widget2));

        expect(widget2.value, equals(0));
      });

      testWidgets(
        'does not reset state when shouldResetStage returns false',
        (WidgetTester tester) async {
          final widget1 = _TestWidget();
          await tester.pumpWidget(MaterialApp(home: widget1));

          widget1.value++;
          await tester.pumpAndSettle();

          final widget2 = _TestWidget();
          await tester.pumpWidget(MaterialApp(home: widget2));

          expect(widget2.value, equals(1));
        },
      );
    });

    test('throws NoSuchMethod', () {
      final widget = _TestWithReset();
      expect(widget.cantBeCalled, throwsNoSuchMethodError);
    });
  });
}
