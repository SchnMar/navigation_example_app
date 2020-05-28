import 'package:flutter/material.dart';
import 'package:navigationexampleapp/some_page.dart';

import 'cupertino_home_scaffold.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.timeline;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.timeline: GlobalKey<NavigatorState>(),
    TabItem.map: GlobalKey<NavigatorState>(),
    TabItem.share: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.timeline: (_) => SomePage(),
      TabItem.map: (_) => SomePage(),
      TabItem.share: (context) =>
          PostPage(), //Should be displayed with Navigator.push...,
      TabItem.account: (_) => SomePage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
      ),
    );
  }
}
