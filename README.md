<h1 align="center">Stateless</h1>

<h3 align="center">A stateless stateful state management package that is not stateless.<h3>

<p align="center">
<a href="https://github.com/wolfenrain/stateless/actions"><img src="https://github.com/wolfenrain/stateless/workflows/ci/badge.svg" alt="stateless"></a>
<a href="https://github.com/wolfenrain/stateless/actions"><img src="https://raw.githubusercontent.com/wolfenrain/stateless/main/coverage_badge.svg" alt="coverage"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://pub.dev/packages/stateless"><img src="https://img.shields.io/pub/v/stateless.svg" alt="pub package"></a>
</p>

---

> **DISCLAIMER**: Please do not use this package in production, it uses Dart Magic under the hood that could break whenever Flutter wants it to break.

## Introduction

The goal of this package is to see if we can have state management without having to care about state management. The learning curve of Stateless should be at a minimal, knowledge developers have from known Flutter APIs should be transferable, like `initState`, `dispose` and `build`.

## Getting Started

In your flutter project, add the following in your `pubspec.yaml`:

```yaml
  dependencies:
    stateless: ^0.1.0
```

## Usage

The classic Flutter Counter Widget, rewritten with Stateless:

```dart
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

// We define the interface that will describe our state data.
abstract class MyCounterState {
  late int counter;
}

// We extends from Stateless to create our stateless stateful widget.
class MyHomePage extends Stateless implements MyCounterState {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  void initState() {
    super.initState();
    // Initialize our state data.
    counter = 0;
  }

  void showSnackBar() {
    // We can access the BuildContext from anywhere in our widget.
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
            // Update the counter by just simply incrementing it.
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
```

As you can see the API is barely any different from normal Flutter widgets, by extending from `Stateless` and implementing our state interface we can just update the interface properties and it will automatically know that it's state has changed and therefore triggers a rebuild.

## Accessing state data in a child

Quite often you want to access state data from a parent in the tree, well Stateless is capable of doing that for you!

Lets re-imagine the above counter app into two parts, one is the `Stateless` widget and the second part is a normal `StatelessWidget` that displays the counter value.

```dart
class MyHomePage extends Stateless implements MyCounter {
  ... 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      // We build our custom text counter widget here.
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
    // We can then observe our MyCounter for state changes.
    final myCounter = context.observe<MyCounter>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('You have pushed the button this many times:'),
        Text(
          '${myCounter.counter}',
          style: Theme.of(context).textTheme.headline4,
        ),
      ],
    );
  }
}
```

Our `MyCounterText` widget can simply observe the state of our `MyCounter` and read the current `counter` value from it.

## Contributing

Interested in contributing? We love pull request! See the [Contribution](CONTRIBUTING.md) document for more information.