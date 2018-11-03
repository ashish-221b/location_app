import 'package:flutter/material.dart';
import 'session.dart';
import 'config.dart';
import 'dart:convert' as JSON;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  final String login_url= config.url + config.signup;
  final _formKey = GlobalKey<FormState>();
  final control_usr = TextEditingController();
  final control_pwd = TextEditingController();
  final control_pwd_con = TextEditingController();

  @override
  void dispose(){
    control_usr.dispose();
    control_pwd.dispose();
    control_pwd_con.dispose();
    super.dispose();
  }

  void _updatestate(BuildContext context, String response) {
    setState((){
      if(response.isEmpty){
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Aw Snap! something went wrong')));
      }else{
        final json = JSON.jsonDecode(response);
        if(json["status"]){
          Navigator.pushReplacementNamed(context, '/');
        }else{
          if(json["message"].contains("duplicate key")){
            print(json["message"]);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("User Name already exists")));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signup"),
        ),
        body: Builder(
          builder: (BuildContext context) { return Form(
            key: _formKey,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
//                  child : Text('Username'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'UserName',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  controller: control_usr,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
//                  child : Text('Password'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  obscureText: true,
                  controller: control_pwd,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,16.0,0.0,0.0),
//                  child : Text('Confirm Password'),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  obscureText: true,
                  controller: control_pwd_con,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.lightBlueAccent.shade100,
                        elevation: 5.0,
                        child:MaterialButton(
                          minWidth: 400.0,
                          height: 50.0,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if(control_pwd.text!=control_pwd_con.text){
                                setState(() {
                                  Scaffold.of(context)
                                      .showSnackBar(SnackBar(content: Text('Passwords did not match')));
                                  control_pwd.clear();
                                  control_pwd_con.clear();
                                });
                              }
                              else{
                                Session messenger = new Session();
                                messenger.post(login_url, {"userid" : control_usr.text,"password" : control_pwd.text})
                                    .then((t) => this._updatestate(context, t));
                              }
                            }
                          },
                          color: Colors.lightBlueAccent,
                          child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 8.0),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.lightBlueAccent.shade100,
                        elevation: 5.0,
                        child: MaterialButton(
                          minWidth: 400.0,
                          height: 50.0,
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          color: Colors.lightBlueAccent,
                          child: Text('Log In', style: TextStyle(color: Colors.white)),
                        ),
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
