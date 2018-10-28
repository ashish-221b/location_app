import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'session.dart';
import 'dart:convert' as JSON;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'chatdetails.dart';
class NewConv extends StatefulWidget {
  @override
  _NewConvState createState() => new _NewConvState();
}

class _NewConvState extends State<NewConv> {
  Session messenger = new Session();
  final String logout_url="http://192.168.0.110:8080/Server/LogoutServlet";
  final String create_url= "http://192.168.0.110:8080/Server/CreateConversation";
  final String Auto_url= "http://192.168.0.110:8080/Server/AutoCompleteUser";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text("Create Conversation"),
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
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0,),
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                style: DefaultTextStyle.of(context).style.copyWith(
                    fontStyle: FontStyle.italic
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'What are you looking for?'
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.add),
                  title: Text(suggestion['det']),
                  subtitle: Text(suggestion['id']),
                );
              },
              onSuggestionSelected: (suggestion) async{
                  await messenger.get(create_url+"?other_id="+suggestion["id"]).then((t)=>setState((){
                    final ret = JSON.jsonDecode(t);
                    print(ret);
                    if(ret["status"]){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => chatDetails(target_id: suggestion["id"])
                      )
                      );
                    }
                    else{
                      if(ret["message"].contains("already exists")){
                        print(suggestion["id"]);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => chatDetails(target_id: suggestion["id"])
                        )
                        );
                      }
                      else if(ret["message"]=="Not logged in"){
                        Navigator.pushReplacementNamed(context, '/');
                      }
                      else{
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    }
                  }));
//                Navigator.of(context).push(MaterialPageRoute(
//                    builder: (context) => ProductPage(product: suggestion)
//                )
//                );
              },
            ),
          ],
        ),
      ),
    );
      }
    Future<List> getSuggestions(String query) async {
//    print(query);
    final s = await messenger.get(Auto_url+"?term="+query);
    final l = JSON.jsonDecode(s);
//    print(l[0]);
//    print(tok[1].split(": ")[1]);
//    print(j["uid"]);
    return List.generate(l.length, (index) {
      return {
        'det': l[index]["label"].split(",")[0].split(": ")[1] +" "+ l[index]["label"].split(",")[1].split(": ")[1] +" "+ l[index]["label"].split(",")[2].split(": ")[1],
        'id': l[index]["value"]
      };
    });
  }
}