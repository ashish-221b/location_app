import 'package:flutter/material.dart';
import 'config.dart';

class App_loading extends StatefulWidget {
  @override
  _App_loadingState createState() => new _App_loadingState();
}

class _App_loadingState extends State<App_loading> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
//      key: config.keyboi,
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//          child : Text('Loading'),
        )
      )
    );
  }
}