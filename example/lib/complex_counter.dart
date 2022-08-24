import 'package:flutter/material.dart' hide StatelessWidget;
import 'package:stateless/stateless.dart';

class CounterContainer extends StatefulWidget {
  const CounterContainer({super.key});

  @override
  State<CounterContainer> createState() => _CounterContainerState();
}

class _CounterContainerState extends State<CounterContainer> {
  ValueNotifier<int> counter1 = ValueNotifier(0);
  ValueNotifier<int> counter2 = ValueNotifier(10);

  bool isCounter1Active = true;
  bool isShowingPreviousValue = true;

  ValueNotifier<int> get activeCounter =>
      isCounter1Active ? counter1 : counter2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter ${isCounter1Active ? '1' : '2'}:'
              '${activeCounter.value}',
            ),
            if (isShowingPreviousValue) CounterCache(counter: activeCounter),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isShowingPreviousValue = !isShowingPreviousValue;
                });
              },
              child: const Text('Toggle previous value'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isCounter1Active = !isCounter1Active;
                });
              },
              child: const Text('Toggle active Counter'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          activeCounter.value = activeCounter.value + 1;
        }),
        tooltip: 'Increment active counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}

abstract class CounterCacheInterface {
  late int value;
  late int? previousValue;
  late VoidCallback onCount;
}

class CounterCache extends StatelessWidget implements CounterCacheInterface {
  CounterCache({
    super.key,
    required this.counter,
  });

  final ValueNotifier<int> counter;

  @override
  void initState() {
    super.initState();
    previousValue = null;
    value = counter.value;
    onCount = () {
      previousValue = value;
      value = counter.value;
    };
    counter.addListener(onCount);
  }

  @override
  void dispose() {
    super.dispose();
    counter.removeListener(onCount);
  }

  @override
  bool shouldResetState(CounterCache oldWidget) {
    return oldWidget.counter != counter;
  }

  @override
  Widget build(BuildContext context) {
    return Text("previousValue: ${previousValue ?? "I don't know"}");
  }
}
