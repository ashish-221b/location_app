// Add a stateful widget

import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'chatdetails.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState(){
    super.initState();

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find your Location")),
      body: Center(
          child: RaisedButton(
          onPressed: () {
            print("Get Location button pressed");
          },
          child: Text('Get Location'),
        )
      ),
      drawer: App_Drawer(),
    );

  }
}