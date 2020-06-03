import 'package:flutter/material.dart';
import 'controller/controller_page.dart';
import 'game/game_page.dart';
import 'image/image_page.dart';
import 'table/table_page.dart';
import 'jump/jump_page.dart';
import 'middle/middle_page.dart';
import 'childSize/child_size.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Validation Sandbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, Widget Function(BuildContext)>{
        '/': (BuildContext context) => MyHomePage(),
        '/game': (BuildContext context) => GamePage(),
        '/image': (BuildContext context) => ImagePage(),
        '/table': (BuildContext context) => TablePage(),
        '/jump': (BuildContext context) => JumpPage(),
        '/middle': (BuildContext context) => MiddlePage(),
        '/child_size': (BuildContext context) => ChildSizePage(),
        '/controller': (BuildContext context) => ControllerPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Validation Sandbox'),
      ),
      body: ListView(
        children: <Widget>[
          MyListItem(
            route: '/game',
            subtitle: 'The original hexagon grid demo.',
            title: 'Game Board',
          ),
          MyListItem(
            route: '/image',
            subtitle: 'Like a photo viewer app.',
            title: 'Image Viewer',
          ),
          MyListItem(
            route: '/table',
            subtitle: 'Like a spreadsheet of data, scrollable in two dimensions.',
            title: 'Table',
          ),
          MyListItem(
            route: '/jump',
            subtitle: 'Demonstrates Sebastien\'s jump bug',
            title: 'Jump Bug',
          ),
          MyListItem(
            route: '/middle',
            subtitle: 'A small InteractiveViewer in the middle of the page, with boundaries bigger than the viewport.',
            title: 'Middle Edge Case',
          ),
          MyListItem(
            route: '/controller',
            subtitle: 'Demonstrates using the controller to reset',
            title: 'Controller Demo',
          ),
          MyListItem(
            route: '/child_size',
            subtitle: 'Trying out a child whose min size is bigger than viewport, but whose max size is even bigger yet.',
            title: 'Child Size',
          ),
        ],
      ),
    );
  }
}

class MyListItem extends StatelessWidget {
  MyListItem({
    Key key,
    this.route,
    this.subtitle,
    this.title,
  }) : super(key: key);

  final String route;
  final String subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        margin: EdgeInsets.all(12.0),
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ),
      ),
    );
  }
}
