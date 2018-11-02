import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert' as JSON;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
//  final String login_url= "http://192.168.0.110:8080/Server/LoginServlet";
  final String login_url= "http://10.130.155.5:8080/SpotMe/slogin";
  final _formKey = GlobalKey<FormState>();
  final control_usr = TextEditingController();
  final control_pwd = TextEditingController();

  @override
  void dispose(){
    control_usr.dispose();
    control_pwd.dispose();
    super.dispose();
  }

  void _updatestate(BuildContext context, String response) {
    setState((){
      if(response.isEmpty){
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Aw Snap! something went wrong')));
      }else{
        final json = JSON.jsonDecode(response);
        print(json);
        if(json["status"]){
          print("hola");
          Navigator.pushReplacementNamed(context, '/home');
        }else{
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(json["message"])));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Builder(
          builder: (BuildContext context) { return Form(
            key: _formKey,
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
                  controller: control_usr,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
                  child : Text('Token'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  obscureText: true,
                  controller: control_pwd,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Session messenger = new Session();
                            messenger.post(login_url, {"username" : control_usr.text,"password" : control_pwd.text})
                                .then((t) => this._updatestate(context, t));
                          }
                        },
                        child: Text('Submit'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text('Sign Up'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
          },
        )
    );
  }
}
