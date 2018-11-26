import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:async';
import 'session.dart';
import 'dart:convert' as JSON;
import 'drawer.dart';

const String STA_DEFAULT_SSID = "STA_SSID";
const String STA_DEFAULT_PASSWORD = "STA_PASSWORD";
const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

const String AP_DEFAULT_SSID = "AP_SSID";
//void main() => runApp(new MyApp());

enum ClientDialogAction {
  cancel,
  ok,
}
class WifiApi{
  static final WifiApi _wifi = new WifiApi._internal();
  factory WifiApi(){
    return _wifi;
  }
  List<WifiNetwork> _htResultNetwork;
  var _List_of_wifi;
  var _standard_wifi;
  WifiApi._internal(){
    _List_of_wifi = [];
    _standard_wifi = ['eduroam', 'IITB-Wireless', 'IITB-Guest'];
  }

  Future<List<dynamic> > loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = new List<WifiNetwork>();
    }
    _List_of_wifi = [];
    _htResultNetwork = htResultNetwork;
    getWidgetsForAndroid();
//    print(_List_of_wifi.toString());
    return _List_of_wifi;
  }
  getWidgetsForAndroid() {
    if (_htResultNetwork != null && _htResultNetwork.length > 0) {
      List<ListTile> htNetworks = new List();

      _htResultNetwork.forEach((oNetwork) {

        // Check for wifi in standard wifi;s
        if(_standard_wifi.contains(oNetwork.ssid)||true){
//          print(oNetwork.ssid + " " + oNetwork.bssid + " : " + oNetwork.level.toString());

          dynamic _temp_data = {};
          _temp_data['ssid'] = oNetwork.ssid;
          _temp_data['bssid'] = oNetwork.bssid;
          _temp_data['signal'] = oNetwork.level;
          _List_of_wifi.add(JSON.json.encode(_temp_data));

        }
//          htNetworks.add(
//            new ListTile(
//              title: new Text(oNetwork.ssid + " " + oNetwork.bssid + " : " + oNetwork.level.toString()),
//            ),
//          );
      });
    } else {
      print("Scanning");
    }
  }
}
