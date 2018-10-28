import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'NewConv.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'chatdetails.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Location on Wheels',
      initialRoute: '/',
      routes: {
        '/' : (context) => Login(),
        '/home' : (context) => Home(),
        '/Create': (context) => NewConv(),
      },
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
