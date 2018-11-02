import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'register.dart';
import 'NewConv.dart';
import 'Signup.dart';
import 'Wifi_Api.dart';
import 'loc_feedback.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Location Finder',
      initialRoute: '/',
      routes: {
        '/' : (context) => Login(),
        '/home' : (context) => Home(),
        '/Create': (context) => NewConv(),
        '/signup' : (context) => Signup(),
        '/wifi_loc' : (context) => WifiLoc(),
        '/register' : (context) => Register(),
        '/loc_feedback' : (context) => Loc_feedback(),
      },
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
