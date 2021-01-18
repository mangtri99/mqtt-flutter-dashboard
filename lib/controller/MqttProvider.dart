import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum MQTTAppConnectionState { connected, disconnect, connecting }
enum MqttSubscribe { yes, no }

class MqttAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnect;

  MqttSubscribe _subscribe = MqttSubscribe.no;

  String _receivedTemp = '';
  String _receivedOksigen = '';
  String _receivedBpm = '';
  String _receivedTekanan = '';
  String _receivedId = '';
  String _receivedName = '';
  String _timestamp = '';
  //setter

  void setReceivedTemp(String text) {
    _receivedTemp = text;
    notifyListeners();
  }

  void setReceivedBpm(String text) {
    _receivedBpm = text;
    notifyListeners();
  }

  void setReceivedOksigen(String text) {
    _receivedOksigen = text;
    notifyListeners();
  }

  void setReceivedTekanan(String text) {
    _receivedTekanan = text;
    notifyListeners();
  }

  void setReceivedUser(String id) {
    _receivedId = id;
    // _receivedName = name;
    notifyListeners();
  }

  void setTimestamp(String date) {
    _timestamp = date;
    notifyListeners();
  }

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  void setAppMqttSubscribe(MqttSubscribe subscribe) {
    _subscribe = subscribe;
    notifyListeners();
  }

  //getter
  String get getReceivedTemp => _receivedTemp;
  String get getReceivedBpm => _receivedBpm;
  String get getReceivedOksigen => _receivedOksigen;
  String get getReceivedTekanan => _receivedTekanan;
  String get getReceivedUserId => _receivedId;
  String get getTimestamp => _timestamp;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  MqttSubscribe get getMqttSubscribe => _subscribe;
}
