import 'package:flutter/material.dart';
import 'session.dart';
import 'config.dart';
import 'dart:convert' as JSON;
import 'loading.dart';
import 'dart:async';import 'Wifi_Api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final String login_url= config.url + config.login;
  final String ping_url = config.url+config.ping;
  StreamSubscription periodicSub;
//  final String login_url= "http://10.130.155.5:8080/SpotMe/slogin";
  final _formKey = GlobalKey<FormState>();
  final control_usr = TextEditingController();
  final control_pwd = TextEditingController();
  WifiApi wa = new WifiApi();
  Session messenger = new Session();
  final flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState(){
    config.isLoading = false;
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
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
          periodicSub = new Stream.periodic(const Duration(milliseconds: 10000))
              .take(10000)
              .listen((_){
//            print("beacon");
            wa.loadWifiList().then((t) {
//              print(t.toString());
              messenger.post(ping_url,{"wifi-data" : t.toString()}).then((t1) {
                var data = JSON.json.decode(t1);
                print(data);
                if( data['data']['next_lecture'] != "No Lecture Found"){
                  _showNotification('Lecture Scheduled at ' + data['data']['next_lecture']['staet_time'], data['data']['next_lecture']['lecture_title']);
                }
                print(t1.toString());
                if(data["logged_in"]==false){
                  periodicSub.cancel();
                }
              });
            });
          });
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

  Future _showNotification(title, body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'id', 'name', 'description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: '');
  }

  @override
  Widget build(BuildContext context) {
    print(login_url);

  if(config.isLoading){
    return App_loading();
  }
  return Scaffold(
    resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
          child: Form(
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
//                              config.isLoading = true;
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
          ),
        );
        },
      )
    );
  }
}
