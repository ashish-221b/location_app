import 'package:flutter/material.dart';
import 'login.dart';
import 'Wifi_Api.dart';
import 'NewConv.dart';
import 'Signup.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'chatdetails.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'whatasap on Wheels',
      initialRoute: '/',
      routes: {
        '/' : (context) => Login(),
        '/signup' : (context) => Signup(),
        '/home' : (context) => WifiLoc(),
        '/Create': (context) => NewConv(),
      },
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
