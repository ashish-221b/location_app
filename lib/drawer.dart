import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'chatdetails.dart';
import 'session.dart';

import 'package:flutter/services.dart';

class App_Drawer extends StatelessWidget {
  final String logout_url="http://192.168.0.110:8080/Server/LogoutServlet";
  Session messenger = new Session();
  @override
  Widget build(BuildContext context){
    return Drawer(
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
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text('Add Courses'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/register');
            },
          ),
          ListTile(
            title: Text('Get Location'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacementNamed(context, '/wifi_loc');
            },
          ),
          ListTile(
            title: Text('Send Location Feedback'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              print("Send Location Feedback");
              Navigator.pushReplacementNamed(context, '/loc_feedback');
            },
          ),
          ListTile(
            title: Text('My Account'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              print("Choosen My Account");
//              Navigator.pushReplacementNamed(context, '/wifi_loc');
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              print(logout_url);
                messenger.get(logout_url).then((t){
                  print(t);
                  final m = JSON.jsonDecode(t);
                  if(m["status"]){
                    Navigator.pushReplacementNamed(context, '/');
                  }
                  else{
                    Navigator.pushReplacementNamed(context, '/');
                  }
                });
            },
          )
        ],
      ),
    );
  }
}