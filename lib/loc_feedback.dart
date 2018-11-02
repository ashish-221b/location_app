// Add a stateful widget

import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'chatdetails.dart';
import 'drawer.dart';

class Loc_feedback extends StatefulWidget {
  @override
  _Loc_feedbackState createState() => new _Loc_feedbackState();
}

class _Loc_feedbackState extends State<Loc_feedback> {

  final _formKey_feed = GlobalKey<FormState>();
  final control_location = TextEditingController();
//  final control_token = TextEditingController();

  List<DropdownMenuItem<String>> _dropDropMenuItems = [new DropdownMenuItem(value: "AAA", child: new Text("abc")),
  new DropdownMenuItem(value: "BBB", child: new Text("bcd"))];
  String curr_value;
//  print(_dropDropMenuItems);

  @override
  void dispose(){
    control_location.dispose();
//    control_token.dispose();
    super.dispose();
  }

  @override
  void initState(){
//    curr_value = _dropDropMenuItems[0].value;
    super.initState();

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Send Your Feedback")),
      body: Center(
          child: Form(
            key: _formKey_feed,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                DropdownButton(
                  value: curr_value,
                  items: _dropDropMenuItems,
                  onChanged: (X){
                    setState((){
                      curr_value = X;
                      print(curr_value);
                    });
                  }
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
//                      if (_formKey_reg.currentState.validate()) {
//                        Session messenger = new Session();
//                        messenger.post(login_url, {"userid" : control_course.text,"password" : control_token.text})
//                            .then((t) => this._updatestate(context, t));
//                      }
//                      print(curr_value);
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