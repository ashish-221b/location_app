import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert' as JSON;

class chatDetails extends StatefulWidget {
  const chatDetails({
    Key key,
    @required this.target_id
  }) : super(key : key);
  final String target_id;

  @override
  _chatState createState() => new _chatState();
}

class message{
  const message({this.timestamp, this.sender, this.content});
  final timestamp;
  final sender;
  final content;
}

class _chatState extends State<chatDetails>{
  final List<message> _conversation = <message>[];
  final control_msg = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Session messenger = new Session();
  static const String new_url = "http://192.168.0.110:8080/Server/NewMessage";
  static const String convd_url = "http://192.168.0.110:8080/Server/ConversationDetail";
  final String logout_url="http://192.168.0.110:8080/Server/LogoutServlet";

  @override
  void dispose(){
    control_msg.dispose();
    super.dispose();
  }

  void _updatestate(BuildContext context, String response) {
    setState((){
      if(response.isEmpty){
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Aw Snap! something went wrong')));
      }else{
        final json = JSON.jsonDecode(response);
        if(!json["status"]){
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(json["message"])));
        }else{
          _load();
        }
      }
    });
  }

  _load() async{
    await messenger.get(convd_url + "?other_id=" + Uri.encodeComponent(widget.target_id)).then((t)=>
        setState((){
          if(!t.isEmpty) {
            final par = JSON.jsonDecode(t);
            if(par["status"]) {
              for(int i=0;i < par["data"].length;i++) {
                message p = new message(timestamp: par["data"][i]["timestamp"],
                    sender: par["data"][i]["uid"],
                    content: par["data"][i]["text"]);
                _conversation.add(p);
              }
            }
          }
        }
        )
    );
  }

  Widget _messageBuild(message msg) {
    return new ListTile(
      title: new Text(msg.sender),
      subtitle: new Text(msg.content),
    );
  }

  Widget _threadBuild(){
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 2*_conversation.length,
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;
          return _messageBuild(_conversation[index]);
        }
    );
  }
  @override
  void initState(){
    super.initState();
    _load();
  }

  @override
  Widget build (BuildContext context){
    return new Scaffold(         // Add 6 lines from here...
      appBar: new AppBar(
        title: Text(widget.target_id),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.home), onPressed: (){
            Navigator.pushReplacementNamed(context, '/home');
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
        ],

      ),
      body: Builder (
        builder : (BuildContext context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _threadBuild(),
                /*Column(
                  children: <Widget>[
                    Text('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nhbh'),
                  ],
                ),*/
              ),
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: control_msg,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Session messenger = new Session();
                            messenger.post(new_url, {"other_id" : widget.target_id, "msg" : control_msg.text})
                                .then((t) => this._updatestate(context, t));
                            control_msg.clear();
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 70.0),
                    ),
                  ],
                ),
              )

            ],
          );
        }
      ),
    );
  }
}