/*
 * Based on an answer by Richard Heap on stackoverflow.
 * Original link:
 * https://stackoverflow.com/questions/50299253/flutter-http-maintain-php-session
 */


import 'dart:async';
import 'package:http/http.dart' as http;

class Session {
  static final Session _session = new Session._internal();
  factory Session(){
    return _session;
  }
  Session._internal();

//  Cookie cook = new cookie();
  Map<String, String> headers = {};

  Future<String> get(String url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    print(headers);
    return response.body;
  }

  Future<String> post(String url, dynamic data) async {
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    print(headers);
    return response.body;
  }

  void updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    print(rawCookie);
    if (rawCookie != null) {
      int index = rawCookie.indexOf('sessionid');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(index);
    }
  }
}