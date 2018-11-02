import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'register.dart';
import 'NewConv.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'chatdetails.dart';
import 'Signup.dart';
import 'Wifi_Api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Location Finder',
      initialRoute: '/',
      routes: {
        '/' : (context) => Home(),
        '/home' : (context) => Home(),
        '/Create': (context) => NewConv(),
        '/signup' : (context) => Signup(),
        '/wifi_loc' : (context) => WifiLoc(),
        '/register' : (context) => Register(),
      },
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
