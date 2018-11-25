// Add a stateful widget

import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert';
import 'config.dart';
import 'drawer.dart';
import 'session.dart';
import 'loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  Session messenger = new Session();
  final String home_url= config.url + config.home;
  var _courses;


  @override
  void initState(){
    config.isLoading = true;
    messenger.get(home_url).then((data) {
      print(data);
      Map<String, dynamic> course_data = json.decode(data);
      if(course_data['status']){
        setState(() {
          _courses = course_data['data'];
          print(_courses);
          config.isLoading = false;
        });
      }

    });
    print("in_initstate");
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Find your Location")),
        body: Text("hello")
      );
    }
//    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    if(!config.isLoading){
      return Scaffold(
        appBar: AppBar(title: Text("Find your Location")),
        body: new ListView.builder(
            itemCount: _courses.length,
            itemBuilder: (BuildContext context, int index){
              return new Text(_courses[index].toString());
            }
        ),
        drawer: new App_Drawer(),
      );
    } else{
      return App_loading();
    }


  }
}