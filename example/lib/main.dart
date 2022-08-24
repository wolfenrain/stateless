import 'package:flutter/material.dart';
import 'package:stateless/stateless.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateless Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Stateless Demo Home Page'),
    );
  }
}

class MyCounter {
  late int counter;
}

class MyHomePage extends Stateless implements MyCounter {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  void initState() {
    super.initState();
    counter = 0;
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('The count is at: $counter')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: MyCounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => counter++,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: showSnackBar,
            tooltip: 'Show SnackBar',
            child: const Icon(Icons.lightbulb),
          ),
        ],
      ),
    );
  }
}

class MyCounterText extends StatelessWidget {
  const MyCounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final myHomePage = context.observe<MyHomePage>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('You have pushed the button this many times:'),
        Text(
          '${myHomePage.counter}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}
