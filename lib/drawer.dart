import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'config.dart';

import 'package:flutter/services.dart';

class App_Drawer extends StatefulWidget {
  @override
  _App_DrawerState createState() => new _App_DrawerState();
}

class _App_DrawerState extends State<App_Drawer> {

  final String logout_url= config.url + config.logout;
  final String ping_url = config.url+config.ping;
  StreamSubscription periodicSub;
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
          new ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          new ListTile(
            title: Text('Add Courses'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/register');
            },
          ),
          new ListTile(
            title: Text('Get Location'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/wifi_loc');
            },
          ),
          new ListTile(
            title: Text('Send Location Feedback'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              print("Send Location Feedback");
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/loc_feedback');
            },
          ),
          new ListTile(
            title: Text('My Account'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              print("Choosen My Account");
              periodicSub = new Stream.periodic(const Duration(milliseconds: 1000))
                  .take(10)
                  .listen((_){
                    messenger.post(ping_url,{"data" : "Hello There!!"}).then((t) => print(t));
                    print('tick');
                  });
//              Navigator.pushReplacementNamed(context, '/wifi_loc');
            },
          ),
          new ListTile(
            title: Text('Logout'),
            onTap: () {
              print(logout_url);
                messenger.get(logout_url).then((t){
                  print(t);
                  final m = JSON.jsonDecode(t);
                  if(m["status"]){
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/');
                  }
                  else{
                    Navigator.pop(context);
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