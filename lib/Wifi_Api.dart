import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'session.dart';
import 'dart:convert' as JSON;
const String STA_DEFAULT_SSID = "STA_SSID";
const String STA_DEFAULT_PASSWORD = "STA_PASSWORD";
const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.WPA;

const String AP_DEFAULT_SSID = "AP_SSID";
//void main() => runApp(new MyApp());

enum ClientDialogAction {
  cancel,
  ok,
}

class WifiLoc extends StatefulWidget {
  @override
  _WifiLocState createState() => new _WifiLocState();
}

class _WifiLocState extends State<WifiLoc> {
  bool _isWiFiAPEnabled = false;
  WIFI_AP_STATE _iWiFiState = WIFI_AP_STATE.WIFI_AP_STATE_DISABLED;
  List<APClient> _htResultClient;
  bool _isWiFiAPSSIDHidden = false;
  String _sAPSSID = "";
  String _sPreSharedKey = "";
  String _sPreviousAPSSID = "";
  String _sPreviousPreSharedKey = "";
  Session messenger = new Session();
  final String logout_url="http://192.168.0.110:8080/Server/LogoutServlet";
  List<WifiNetwork> _htResultNetwork;
  bool _isEnabled = false;
  bool _isConnected = false;
  Map<String, bool> _htIsNetworkRegistered = new Map();
  String _sSSID = "";
  String _sBSSID = "";
  int _iCurrentSignalStrength = 0;
  int _iFrequency = 0;
  String _sIP = "";

  @override
  initState() {
    super.initState();
  }
  loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = new List<WifiNetwork>();
    }
    if (!mounted) return;

    setState(() {
      _htResultNetwork = htResultNetwork;
    });
  }
  isEnabled() async {
    bool isEnabled;
    try {
      isEnabled = await WiFiForIoTPlugin.isEnabled();
    } on PlatformException {
      isEnabled = false;
    }
    if (!mounted) return;
    setState(() {
      _isEnabled = isEnabled;
    });
  }

  isConnected() async {
    bool isConnected;
    try {
      isConnected = await WiFiForIoTPlugin.isConnected();
    } on PlatformException {
      isConnected = false;
    }
    if (!mounted) return;

    setState(() {
      _isConnected = isConnected;
    });
  }
  getSSID() async {
    String ssid;
    try {
      ssid = await WiFiForIoTPlugin.getSSID();
    } on PlatformException {
      ssid = "";
    }
    if (!mounted) return;

    setState(() {
      _sSSID = ssid;
    });
  }

  getBSSID() async {
    String bssid;
    try {
      bssid = await WiFiForIoTPlugin.getBSSID();
    } on PlatformException {
      bssid = "";
    }
    if (!mounted) return;

    setState(() {
      _sBSSID = bssid;
    });
  }

  getCurrentSignalStrength() async {
    int iCurrentSignalStrength;
    try {
      iCurrentSignalStrength = await WiFiForIoTPlugin.getCurrentSignalStrength();
    } on PlatformException {
      iCurrentSignalStrength = 0;
    }
    if (!mounted) return;

    setState(() {
      _iCurrentSignalStrength = iCurrentSignalStrength;
    });
  }

  getFrequency() async {
    int iFrequency;
    try {
      iFrequency = await WiFiForIoTPlugin.getFrequency();
    } on PlatformException {
      iFrequency = 0;
    }
    if (!mounted) return;

    setState(() {
      _iFrequency = iFrequency;
    });
  }

  getIP() async {
    String sIP;
    try {
      sIP = await WiFiForIoTPlugin.getIP();
    } on PlatformException {
      sIP = "";
    }
    if (!mounted) return;

    setState(() {
      _sIP = sIP;
    });
  }
   getWidgetsForAndroid() {
    if (_htResultNetwork != null && _htResultNetwork.length > 0) {
      List<ListTile> htNetworks = new List();

      _htResultNetwork.forEach((oNetwork) {
        setState(() {
          print(oNetwork.ssid + " " + oNetwork.bssid + " : " + oNetwork.level.toString());
//          htNetworks.add(
//            new ListTile(
//              title: new Text(oNetwork.ssid + " " + oNetwork.bssid + " : " + oNetwork.level.toString()),
//            ),
//          );
        });
      });
    } else {
      print("Scanning");
    }
  }
  @override
  Widget build(BuildContext poContext) {
    final defaultTheme = Theme.of(context);
    if (defaultTheme.platform == TargetPlatform.android) {
      return new MaterialApp(
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Get WifiList'),
            actions: <Widget>[
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
//            actions: getActionsForAndroid(),
          ),
          body: new Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                child: new Text("Get Location"),
                onPressed: () {
                  loadWifiList();
                  getWidgetsForAndroid();
                },
          ),
        ),
        ),
      );
    }
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin IoT Wifi app for ???'),
        ),
      ),
    );
  }
}

class PopupCommand {
  String command;
  String argument;

  PopupCommand(this.command, this.argument) {
    ///
  }
}
