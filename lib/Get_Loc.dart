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

class Get_Loc extends StatefulWidget {
  @override
  _Loc_State createState() => new _Loc_State();
}

class _Loc_State extends State<Get_Loc> {

  Session messenger = new Session();
  final String list_loc_url = config.url + config.list_loc;
  final String get_location = config.url + config.get_location;
  final _formKey_feed = GlobalKey<FormState>();
  final control_location = TextEditingController();
  WifiApi wa = new WifiApi();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
//  final control_token = TextEditingController();

  List<DropdownMenuItem<String>> _dropDropMenuItems = [];
//  [new DropdownMenuItem(value: "AAA", child: new Text("abc")),
//  new DropdownMenuItem(value: "BBB", child: new Text("bcd"))];
  String loc_pred = "Press Get Location";

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
//    config.isLoading = true;
//    messenger.get(list_loc_url).then((data) {
//      print(data);
//      List<dynamic> loc_data = JSON.json.decode(data)['data'];
//
//      for (int i = 0; i < loc_data.length; i++) {
//        _dropDropMenuItems.add(new DropdownMenuItem(
//            value: loc_data[i]['location_id'].toString(),
//            child: new Text(loc_data[i]['location_name'].toString())
//        ));
//      }
//      setState(() {
//        print(_dropDropMenuItems);
        config.isLoading = false;
//      });
//    });
    super.initState();

  }
  Widget build(BuildContext context) {
    if(config.isLoading){
      return App_loading();
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Get Your Location")),
      body: Center(
          child: Form(
            key: _formKey_feed,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
                  child : Text(loc_pred),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
//                      print(messenger.toString());
//                      print(wa.toString());
                      wa.loadWifiList().then((t) {
                        print(t.toString());
                        messenger.post(get_location, {
//                          'location' : curr_value.toString(),
                          'wifi-data' : t.toString()
                        }).then((Loc){
                          var dat = JSON.json.decode(Loc);
                          print("GetLOC");
                          print(dat);
                          setState(() {
                            if(dat["status"]==true){
                              loc_pred = dat["location_name"];
                            }
                            else{
                              loc_pred = "No Location found";
                            }
                          });
                        });
                      });
                    },
                    child: Text('Get Location'),
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