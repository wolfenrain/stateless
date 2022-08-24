import 'package:flutter/material.dart' hide StatelessWidget;
import 'package:stateless/stateless.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyCounter {
  late int _counter;
}

class MyHomePage extends StatelessWidget implements MyCounter {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  void initState() {
    super.initState();
    _counter = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _counter++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
