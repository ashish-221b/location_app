import 'package:flutter/material.dart';
import 'session.dart';
import 'config.dart';
import 'dart:convert' as JSON;
import 'loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final String login_url= config.url + config.login;
//  final String login_url= "http://10.130.155.5:8080/SpotMe/slogin";
  final _formKey = GlobalKey<FormState>();
  final control_usr = TextEditingController();
  final control_pwd = TextEditingController();

  @override
  void initState(){
    config.isLoading = false;
    super.initState();
  }

  @override
  void dispose(){
    control_usr.dispose();
    control_pwd.dispose();
    super.dispose();
  }

  void _updatestate(BuildContext context, String response) {
    print(response);
    setState((){
      if(response.isEmpty){
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Aw Snap! something went wrong')));
      }else{
        final json = JSON.jsonDecode(response);
        if(json["status"]){
          Navigator.pushReplacementNamed(context, '/home');
        }else{
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(json["error_msg"])));
//          Navigator.pushReplacementNamed(context, '/');
          config.isLoading = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(login_url);

  if(config.isLoading){
    return App_loading();
  }
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
//                  child : Text('UserName'),
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
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0,horizontal: 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child : Material(
                        borderRadius: BorderRadius.circular(30.0),
                        shadowColor: Colors.lightBlueAccent.shade100,
                        elevation: 5.0,
                        child:MaterialButton(
                          minWidth: 400.0,
                          height: 50.0,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
//                            print(control_usr.text);
                            config.isLoading = true;
                              Session messenger = new Session();
                              messenger.post(login_url, {"userid" : control_usr.text,"password" : control_pwd.text})
                                  .then((t) => this._updatestate(context, t));

                            }
                          },
                          color: Colors.lightBlueAccent,
                          child: Text('Log In', style: TextStyle(color: Colors.white)),
                        ),
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
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        color: Colors.lightBlueAccent,
                        child: Text('Sign Up', style: TextStyle(color: Colors.white)),
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
