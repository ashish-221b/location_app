// Add a stateful widget

import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'chatdetails.dart';
import 'drawer.dart';
import 'config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => new _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey_reg = GlobalKey<FormState>();
  final control_course = TextEditingController();
  final control_token = TextEditingController();
  final String course_register_url= config.url + config.course_register;

  @override
  void dispose(){
    control_course.dispose();
    control_token.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register For Course"),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.home),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },
          )
        ]
      ),
      body: Center(
          child: Form(
            key: _formKey_reg,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
                  child : Text('Course_ID'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  controller: control_course,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
                  child : Text('Course_Token'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  controller: control_token,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey_reg.currentState.validate()) {
                        print('registering for course');
                        Session messenger = new Session();
                        messenger.post(course_register_url, {"course_id" : control_course.text, "session_token" : control_token.text})
                            .then((data) {
                              print(data);
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          )
      ),
      drawer: App_Drawer(),
    );

  }
}