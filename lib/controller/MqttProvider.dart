import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_iot/model/UserModel.dart';
import 'package:mqtt_iot/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MQTTAppConnectionState { connected, disconnect, connecting }
enum MqttSubscribe { yes, no }
enum UserFromApi { yes, no }

class MqttAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState =
      MQTTAppConnectionState.disconnect;

  MqttSubscribe _subscribe = MqttSubscribe.no;
  UserFromApi _userFromApi = UserFromApi.no;

  String _receivedTemp = '';
  String _receivedOksigen = '';
  String _receivedBpm = '';
  String _receivedTekananSistole = '';
  String _receivedTekananDiastole = '';
  String _receivedId = '';
  String _timestamp = '';

  //api service
  UserModel user;
  String _errorMessage;
  bool loading = false;
  bool loadingSave = false;

  Future<bool> fetchUser(idUser) async {
    setLoading(true);
    await ApiService(idUser).fetchUser().then((data) {
      setLoading(false);
      if (data.statusCode == 200) {
        setUser(UserModel.fromJson(json.decode(data.body)));
        setUserFromApi(UserFromApi.yes);
        print(data.body);
      } else {
        Fluttertoast.showToast(
            msg: "Data Not Found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    });
    return isUser();
  }

  Future<http.Response> postData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var _apiUrl = preferences.getString('apiUrl');
    setLoadingSave(true);
    final response = await http.post(_apiUrl + '/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'user_id': user.id.toString(),
          'bpm': _receivedBpm,
          'oksigen': _receivedOksigen,
          'suhu': _receivedTemp,
          'sistole': '120',
          'diastole': '81'
        }));
    setLoadingSave(false);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Data Berhasil Disimpan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0);
    } else {
      Fluttertoast.showToast(
          msg: "Data gagal Disimpan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0);
    }
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setLoadingSave(value) {
    loadingSave = value;
    notifyListeners();
  }

  bool isLoadingSave() {
    return loadingSave;
  }

  void setUser(value) {
    user = value;
    notifyListeners();
  }

  UserModel getUser() {
    return user;
  }

  void setMessage(value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool isUser() {
    return user != null ? true : false;
  }

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

  void setReceivedTekananSistole(String text) {
    _receivedTekananSistole = text;
    notifyListeners();
  }

  void setReceivedTekananDiastole(String text) {
    _receivedTekananDiastole = text;
    notifyListeners();
  }

  void setReceivedUser(String id) {
    _receivedId = id;
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

  void setUserFromApi(UserFromApi userFromApi) {
    _userFromApi = userFromApi;
    notifyListeners();
  }

  //getter
  String get getErrorMessage => _errorMessage;
  String get getReceivedTemp => _receivedTemp;
  String get getReceivedBpm => _receivedBpm;
  String get getReceivedOksigen => _receivedOksigen;
  String get getReceivedTekananSistole => _receivedTekananSistole;
  String get getReceivedTekananDiastole => _receivedTekananDiastole;
  String get getReceivedUserId => _receivedId;
  String get getTimestamp => _timestamp;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  MqttSubscribe get getMqttSubscribe => _subscribe;
  UserFromApi get getUserFromApi => _userFromApi;
}
