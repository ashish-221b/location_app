// Add a stateful widget

import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'chatdetails.dart';
import 'drawer.dart';
import 'config.dart';
import 'loading.dart';
import 'Wifi_Api.dart';

class Loc_feedback extends StatefulWidget {
  @override
  _Loc_feedbackState createState() => new _Loc_feedbackState();
}

class _Loc_feedbackState extends State<Loc_feedback> {

  Session messenger = new Session();
  final String get_loc_url = config.url + config.get_loc;
  final _formKey_feed = GlobalKey<FormState>();
  final control_location = TextEditingController();
  WifiApi wa = new WifiApi();
//  Session messenger = new Session();
//  final control_token = TextEditingController();

  List<DropdownMenuItem<String>> _dropDropMenuItems = [];
//  [new DropdownMenuItem(value: "AAA", child: new Text("abc")),
//  new DropdownMenuItem(value: "BBB", child: new Text("bcd"))];
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
    config.isLoading = true;
    messenger.get(get_loc_url).then((data) {
      print(data);
      List<dynamic> loc_data = JSON.json.decode(data)['data'];

      for (int i = 0; i < loc_data.length; i++) {
        _dropDropMenuItems.add(new DropdownMenuItem(
            value: loc_data[i]['location_id'].toString(),
            child: new Text(loc_data[i]['location_name'].toString())
        ));
      }
      setState(() {
        print(_dropDropMenuItems);
        config.isLoading = false;
      });
    });
    super.initState();

  }
  Widget build(BuildContext context) {
    if(config.isLoading){
      return App_loading();
    }

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
                  hint: Text('Select a location'),
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
//                      print(messenger.toString());
//                      print(wa.toString());
                        wa.loadWifiList().then((t) => print(t.toString()));
//                      if (_formKey_reg.currentState.validate()) {
//                        Session messenger = new Session();
//                        messenger.post(login_url, {"userid" : control_course.text,"password" : control_token.text})
//                            .then((t) => this._updatestate(context, t));
//                      }
                      print(curr_value);

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