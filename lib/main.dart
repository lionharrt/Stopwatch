import 'package:flutter/material.dart';
import 'package:hello_world/stopwatch.dart';
import 'package:hello_world/timer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'StopWatch',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget getTabBar() {
    return TabBar(controller: tabController, tabs: [
      Tab(icon: Icon(Icons.timer)),
      Tab(icon: Icon(Icons.access_time)),
    ]);
  }

  Widget getTabBarPages() {
    return TabBarView(controller: tabController, children: <Widget>[
      StopWatchPage(),
      HourGlassTimerPage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          bottom: getTabBar(),
        ),
        body: getTabBarPages());
  }
}
