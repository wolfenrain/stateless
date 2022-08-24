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

The goal of this package is to see if we can have state management without having to care about state management. The learning curve of `stateless` should be at a minimal, knowledge developers have from the standard Flutter APIs should be transferable, like `initState`, `dispose` and `build`.

## Getting Started

In your flutter project, add the following in your `pubspec.yaml`:

```yaml
  dependencies:
    stateless: ^0.1.0
```

## Usage

The classic Flutter Counter Widget, rewritten with `stateless`:

```dart
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        );
      ),
      floatingActionButton: FloatingActionButton(
        // Update the counter by just simply incrementing it.
        onPressed: () => counter++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

As you can see the API is barely any different from normal Flutter widgets, by extending from `Stateless` and implementing our state interface we can just update the interface properties and it will automatically know that it's state has changed and therefore trigger a rebuild.

## Accessing state data in a child

TODO: write this