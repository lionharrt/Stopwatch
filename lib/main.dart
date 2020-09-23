import 'package:flutter/material.dart';
import 'package:hello_world/stopwatch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StopWatch',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'StopWatch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<StopWatch> stopwatches = [];

  void addStopWatch() {
    setState(() {
      stopwatches.add(StopWatch(removeStopWatch));
    });
  }

  void removeStopWatch(StopWatch stopwatch) {
    final int index = stopwatches.indexOf(stopwatch);
    print('index: $index');
    stopwatches.asMap().forEach((index, value) {
      print('$index ${value.hashCode}');
    });
    print('----------------------');
    stopwatches.removeAt(index);
    stopwatches.asMap().forEach((index, value) {
      print('$index ${value.hashCode}');
    });
    setState(() {});
  }

  void removeAllStopWatches() {
    setState(() {
      stopwatches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.deepOrangeAccent[800],
              ),
              onPressed: removeAllStopWatches)
        ],
      ),
      body: Center(
          child: ListView.builder(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 16.0,
              ),
              itemCount: stopwatches.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return stopwatches[index];
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: addStopWatch,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
