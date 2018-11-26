// Add a stateful widget

import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert';
import 'config.dart';
import 'drawer.dart';
import 'session.dart';
import 'loading.dart';

class courseLec extends StatefulWidget {
  const courseLec({
    Key key,
    @required this.takes_id
  }) : super(key : key);
  final String takes_id;
  @override
  _LecState createState() => new _LecState();
}

class _LecState extends State<courseLec> {
  Session messenger = new Session();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final String home_url= config.url + config.home;
  final courseDet_url = config.url+config.course_details;
  var _courses;
  @override
  void initState(){
    config.isLoading = true;
    super.initState();
    messenger.get(courseDet_url+"?takes_id="+Uri.encodeComponent(widget.takes_id)).then((data) {
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
  }


  @override
  Widget build(BuildContext context) {
    if(!config.isLoading){
      return Scaffold(
        appBar: AppBar(title: Text("Find your Location")),
        body: _buildSuggestions(),
        drawer: new App_Drawer(),
      );
    } else{
      return App_loading();
    }
  }
  Widget _buildRow(dynamic pair) {
    return new ListTile(
      title: new Text(
        pair["lecture_title"],
        style: _biggerFont,
      ),
      subtitle: new Text(
        pair["course_id"]+pair["course_name"],
        style: _biggerFont,
      ),
        isThreeLine: true,//
      onTap: () {      // Add 9 lines from here...
        setState(() {
          _showDialog();
//          messenger.get(courseDet_url+"?takes_id="+Uri.encodeComponent(pair["takes_id"].toString())).then((t) => print(t));
//          Navigator.of(context).pushReplacement(MaterialPageRoute(
//              builder: (context) => chatDetails(target_id: pair.Name)
//          )
//          );
        });
      },
    );
  }
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 2*_courses.length,
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;

          return _buildRow(_courses[index]);
        }
    );
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}