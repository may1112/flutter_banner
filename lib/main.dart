import 'package:flutter/material.dart';

import 'package:flutter_app/common/AppNavigator.dart';
import 'CustomLayout.dart';
import 'package:flutter_app/view/TemplateView.dart';

import 'TemplateLayout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(
                "自定义banner",
              ),
              onPressed: () {
                AppNavigator.push(context, BannerView());
              },
            ),
            RaisedButton(
                child: Text("模板"),
                onPressed: () {
                  AppNavigator.push(context, TemplateLayout());
                })
          ],
        ));
  }
}
