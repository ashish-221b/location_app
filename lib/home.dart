// Add a stateful widget

import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert' as JSON;
import 'chatdetails.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}
class Conv{
  const Conv({this.Name,this.time});
  final String Name;
  final String time;
}
class _HomeState extends State<Home> {
  @override
  Session messenger = new Session();
  final String login_url="http://192.168.0.110:8080/Server/AllConversations";
  final String logout_url="http://192.168.0.110:8080/Server/LogoutServlet";
  List<Conv> _saved = new List<Conv>();
  List<Conv> _filt = new List<Conv>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  bool g=false;
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Chats");
  String data = "Loding....";
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
    super.initState();
    _load();
  }
  Widget build(BuildContext context) {
    return new Scaffold (                   // Add from here...
      appBar: new AppBar(
        title: appBarTitle,
        actions: <Widget>[      // Add 3 lines from here...
          new IconButton(icon: actionIcon,onPressed:(){
            setState(() {
              if ( this.actionIcon.icon == Icons.search){
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  controller: searchField,
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search,color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)
                  ),);}
              else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("Chats");
                _filt=_saved;
                searchField.clear();
              }
            });
          } ,),
          new IconButton(icon: const Icon(Icons.home), onPressed: (){
            Navigator.pushReplacementNamed(context, '/home');
          }),
          new IconButton(icon: const Icon(Icons.create), onPressed: (){
            Navigator.pushReplacementNamed(context, '/Create');
          }),
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
        ],                      // ... to here.
      ),

      body: _buildSuggestions(),
    );

  }
  Widget _buildRow(Conv pair) {
//    final bool alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.Name,
        style: _biggerFont,
      ),
      subtitle: new Text(
        pair.time,
        style: _biggerFont,
      ),                   //
      onTap: () {      // Add 9 lines from here...
        setState(() {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => chatDetails(target_id: pair.Name)
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
      List<Conv> tempList = new List<Conv>();
      for(int i=0;i<_saved.length;i++){
        if((_saved[i].Name).toLowerCase().contains(key.toLowerCase())){
          tempList.add(_saved[i]);
        }
        print((_saved[i].Name).toLowerCase().contains(key.toLowerCase()));
      }
      _filt=tempList;
    }
    print(_saved.length);
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
  _load() async{
    await messenger.get(login_url).then((t)=>
        setState((){
          if(t.isEmpty){
            data="Server Not Reachable";
          }
          else{
            data=t;
            final par = JSON.jsonDecode(t);
            if(par["status"]) {
              for(int i=0;i<par["data"].length;i++) {
                Conv p = new Conv(Name: (par["data"][i]["uid"]==null) ? "" : par["data"][i]["uid"],
                    time: (par["data"][i]["last_timestamp"]==null) ? "" : par["data"][i]["last_timestamp"]);
                _saved.add(p);
              }
            }
            else{
              if(par["message"]=="Not logged in"){
                Navigator.pushReplacementNamed(context, '/');
              }}}
          _filt=_saved;}));
  }
}