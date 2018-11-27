// Add a stateful widget
import 'courseLectures.dart';
import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'config.dart';
import 'drawer.dart';
import 'session.dart';
import 'loading.dart';
import 'dart:convert' as JSON;
import 'dart:core';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Session messenger = new Session();
  final String home_url= config.url + config.home;
  final logout_url = config.url+config.logout;
  final courseDet_url = config.url+config.course_details;
  final String profile_url = config.url+config.profile;
  List<dynamic> _saved = new List<dynamic>();
  List<dynamic> _filt = new List<dynamic>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  bool g=false;
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Courses");
  String data = "Loading....";
  final TextEditingController searchField = new TextEditingController();
  String key="";
  _HomeState(){
    searchField.addListener((){
      if(searchField.text.isEmpty){
        print("loaded");
        setState(() {
          _filt = _saved;
          key = "";
        });
      }
      else{
        setState((){
          print("detected");
          key=searchField.text;
        });
      }
    });
  }


  @override
  void initState(){
    config.isLoading = true;
    messenger.get(profile_url).then((t){
      setState(() {
        var data = JSON.json.decode(t);
        if(data["status"]=true){
          config.usern=data["username"];
          config.usere=data["email"];
          print(config.usern);
          print(data.toString());
        }
      });});
    messenger.get(home_url).then((data) {
      print(data);
      Map<String, dynamic> course_data = JSON.json.decode(data);
      if(course_data['status']){
        setState(() {
          _saved = course_data['data'];
          _filt=_saved;
          print(_saved);
          config.isLoading = false;
        });
      }
    });
//    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    if(!config.isLoading){
      return Scaffold(
        appBar: AppBar(
            title: appBarTitle,
          actions: <Widget>[      // Add 3 lines from here...
            new IconButton(icon: actionIcon,onPressed:(){
              setState(() {
                if ( this.actionIcon.icon == Icons.search){
                  this.actionIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    controller: searchField,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.search,color: Colors.white),
                        hintText: "Search...",
                        hintStyle: new TextStyle(color: Colors.white)
                    ),);}
                else {
                  this.actionIcon = new Icon(Icons.search);
                  this.appBarTitle = new Text("Courses");
                  _filt=_saved;
                  searchField.clear();
                }
              });
            } ,),
            new IconButton(icon: const Icon(Icons.home), onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            }),
//            new IconButton(icon: const Icon(Icons.create), onPressed: (){
//              Navigator.pushReplacementNamed(context, '/Create');
//            }),
            new IconButton(icon: const Icon(Icons.exit_to_app), onPressed: (){
              messenger.get(logout_url).then((t)=>setState((){
                print(t);
                final m = JSON.jsonDecode(t);
                if(m["status"]){
                  Navigator.pushReplacementNamed(context, '/');
                }
                else{
                  Navigator.pushReplacementNamed(context, '/');
                }
              }));
            }),
          ],
            ),
      body:  _buildSuggestions(),
        drawer: new App_Drawer(),
      );
    } else{
      return App_loading();
    }
  }
  Widget _buildRow(dynamic pair) {
//    final bool alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair["course_id"],
        style: _biggerFont,
      ),
      subtitle: new Text(
        pair["course_name"]+"\n"+pair["instructor"],
        style: _biggerFont,
      ),                   //
      onTap: () {      // Add 9 lines from here...
        setState(() {
//          messenger.get(courseDet_url+"?takes_id="+Uri.encodeComponent(pair["takes_id"].toString())).then((t) => print(t));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => courseLec(takes_id : pair["takes_id"].toString())
          )
          );
        });
      },
    );
  }
  Widget _buildSuggestions() {
    print("s");
    print(key);
    print("e");
    if (!(key.isEmpty)) {
      List<dynamic> tempList = new List<dynamic>();
      for(int i=0;i<_saved.length;i++){
        if((_saved[i]["course_id"]).toLowerCase().contains(key.toLowerCase())
            ||(_saved[i]["course_name"]).toLowerCase().contains(key.toLowerCase())
            ||(_saved[i]["instructor"]).toLowerCase().contains(key.toLowerCase())){
          tempList.add(_saved[i]);
        }
//        print((_saved[i].Name).toLowerCase().contains(key.toLowerCase()));
      }
      _filt=tempList;
    }
    print(_filt.length);
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 2*_filt.length,
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;

          return _buildRow(_filt[index]);
        }
    );
  }
}