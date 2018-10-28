// Add a stateful widget

import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'chatdetails.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}
class Conv{
  const Conv({this.Name,this.time});
  final String Name;
  final String time;
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
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Name: qwerty \nRoll No.: *******'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Wifi Api'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
//                Navigator.pushReplacement(context, '/');
              },
            ),
          ],
        ),
      ),
    );

  }
}