import 'package:flutter/foundation.dart';

enum MQTTAppConnectionState { connected, disconnect, connecting }

class MqttAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnect;

  String _receivedTemp = '';
  String _receivedOksigen = '';
  String _receivedBpm = '';
  String _receivedTekanan = '';
  String _receivedId = '';
  String _receivedName = '';

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

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  //getter

  String get getReceivedTemp => _receivedTemp;
  String get getReceivedBpm => _receivedBpm;
  String get getReceivedOksigen => _receivedOksigen;
  String get getReceivedTekanan => _receivedTekanan;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
}
