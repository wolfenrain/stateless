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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: MyCounterText()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyCounterText extends StatelessWidget {
  const MyCounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final myHomePage = context.watch<MyHomePage>();

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
