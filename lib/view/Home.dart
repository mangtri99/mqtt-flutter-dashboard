import 'package:flutter/material.dart';

import 'package:mqtt_iot/controller/MqttManager.dart';
import 'package:mqtt_iot/controller/MqttProvider.dart';
import 'package:mqtt_iot/model/UserModel.dart';

import 'package:provider/provider.dart';
//import 'package:mqtt_iot/utils/blood_icon_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Setting.dart';
import 'Edit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _userController = TextEditingController();
  MqttAppState appState;
  MQTTManager manager;

  var readTopicSend = '';
  var readTopicSave = '';
  var readBroker = '';
  var readTopicMain = '';

  //api service

  // var userId = '';
  // var userName = '';

  bool isSave = false;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  getSavedTopic() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var getTopicSend = preferences.getString('topicSend');
    var getTopicSave = preferences.getString('topicSave');

    var getBroker = preferences.getString('broker');
    var getTopicMain = preferences.getString('topicMain');

    setState(() {
      readTopicSend = getTopicSend;
      readTopicSave = getTopicSave;
      readBroker = getBroker;
      readTopicMain = getTopicMain;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedTopic();
    print('SUHU =>>>>');
  }

  //api service
  void _getUser() {
    if (_userController.text == '') {
      Provider.of<MqttAppState>(context, listen: false)
          .setMessage('Enter Id User');
    } else {
      Provider.of<MqttAppState>(context, listen: false)
          .fetchUser(_userController.text);
      _userController.text = '';
    }
  }

  void configureConnection() {
    manager = MQTTManager(
        host: readBroker, topicMain: readTopicMain, appState: appState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void disconnect() {
    manager.disconnect();
  }

  //home.dart
  // void _publishMessageSend() {
  //   manager.publish(_userController.text, readTopicSend);
  //   _userController.clear();
  //   print('publish message...');
  // }

  // void _publishMessageSave() {
  //   final String message = 'save';
  //   manager.publish(message, readTopicSave);
  //   isSave = true;
  //   if (isSave) {
  //     showInSnackBar('Data Tersimpan');
  //     isSave = false;
  //   }
  // }

  void _publishData() {
    Provider.of<MqttAppState>(context, listen: false).postData();
  }

  @override
  Widget build(BuildContext context) {
    final MqttAppState appStateX = Provider.of<MqttAppState>(context);
    appState = appStateX;

    var suhu = appState.getReceivedTemp.toString();
    var bpm = appState.getReceivedBpm.toString();
    var oksigen = appState.getReceivedOksigen.toString();
    var tekanan = appState.getReceivedTekanan.toString();
    // var userId = appState.getReceivedUserId.toString();

    var timestamp = appState.getTimestamp.toString();
    UserModel user =
        Provider.of<MqttAppState>(context, listen: false).getUser();

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appState.getAppConnectionState ==
                        MQTTAppConnectionState.disconnect
                    ? Colors.red
                    : Colors.greenAccent[400]),
            child: IconButton(
                icon: Icon(
                    appState.getAppConnectionState ==
                            MQTTAppConnectionState.disconnect
                        ? Icons.cloud_off
                        : Icons.cloud_done_outlined,
                    color: Colors.white),
                onPressed: appState.getAppConnectionState ==
                        MQTTAppConnectionState.disconnect
                    ? configureConnection
                    : disconnect),
          ),
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
              })
        ],
        title: Text('IoT Medical Real Time'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[50],
      body: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          onChanged: (value) {
                            appState.setMessage(null);
                          },
                          controller: _userController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'ID Pasien',
                              contentPadding: EdgeInsets.only(left: 8.0)))),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    height: 48,
                    child: RaisedButton(
                      onPressed: appState.getAppConnectionState ==
                              MQTTAppConnectionState.connected
                          ? () {
                              // _publishMessageSend();
                              _getUser();
                            }
                          : null,
                      child: Align(
                        child: appState.isLoading()
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : Text(
                                "Send",
                                style: TextStyle(fontSize: 17.0),
                              ),
                      ),
                      color: Colors.red,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 5.0, bottom: 5.0, right: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "User Information",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        color: Colors.lightBlue[200]),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.only(
                          left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
                      height: 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: user == null
                                  ? Text("ID Pasien : ")
                                  : Text("ID Pasien : " +
                                      user.noPasien.toString())),
                          Container(
                              child: user == null
                                  ? Text("Nama : ")
                                  : Text("Nama : " + user.name)),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Text(timestamp)],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: GridView.count(
                  childAspectRatio: 16 / 10,
                  primary: false,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.device_thermostat,
                                  color: Colors.red,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Edit(
                                                value: 'topicSuhu',
                                                topic: 'Suhu Tubuh',
                                              )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Icon(Icons.more_vert),
                                ),
                              )
                            ],
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              appState.getAppConnectionState ==
                                          MQTTAppConnectionState.connected &&
                                      appState.getMqttSubscribe ==
                                          MqttSubscribe.yes &&
                                      appState.getUserFromApi == UserFromApi.yes
                                  ? Text(
                                      '$suhu \u2103',
                                      style: TextStyle(fontSize: 24),
                                    )
                                  : Text(
                                      '\u2103',
                                      style: TextStyle(fontSize: 18),
                                    )
                            ],
                          )),
                          Expanded(
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Suhu Tubuh",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Edit(
                                                value: 'topicBpm',
                                                topic: 'Detak Jantung',
                                              )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Icon(Icons.more_vert),
                                ),
                              )
                            ],
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              appState.getAppConnectionState ==
                                          MQTTAppConnectionState.connected &&
                                      appState.getUserFromApi == UserFromApi.yes
                                  ? Text(
                                      '$bpm bpm',
                                      style: TextStyle(fontSize: 24),
                                    )
                                  : Text(
                                      'bpm',
                                      style: TextStyle(fontSize: 18),
                                    )
                            ],
                          )),
                          Expanded(
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Detak Jantung",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.album,
                                  color: Colors.red,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Edit(
                                                value: 'topicOksigen',
                                                topic: 'Kadar Oksigen',
                                              )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Icon(Icons.more_vert),
                                ),
                              )
                            ],
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              appState.getAppConnectionState ==
                                          MQTTAppConnectionState.connected &&
                                      appState.getUserFromApi == UserFromApi.yes
                                  ? Text(
                                      '$oksigen %',
                                      style: TextStyle(fontSize: 24),
                                    )
                                  : Text(
                                      '%',
                                      style: TextStyle(fontSize: 18),
                                    )
                            ],
                          )),
                          Expanded(
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Kadar Oksigen",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  Icons.healing,
                                  color: Colors.red,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Edit(
                                                value: 'topicTekanan',
                                                topic: 'Tekanan Darah',
                                              )));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Icon(Icons.more_vert),
                                ),
                              )
                            ],
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              appState.getAppConnectionState ==
                                          MQTTAppConnectionState.connected &&
                                      appState.getUserFromApi == UserFromApi.yes
                                  ? Text(
                                      '$tekanan mmhg',
                                      style: TextStyle(fontSize: 22),
                                    )
                                  : Text(
                                      'mmHg',
                                      style: TextStyle(fontSize: 15),
                                    )
                            ],
                          )),
                          Expanded(
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tekanan Darah",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
          elevation: 10,
          onPressed: appState.getAppConnectionState ==
                      MQTTAppConnectionState.connected &&
                  appState.getMqttSubscribe == MqttSubscribe.yes &&
                  appState.getUserFromApi == UserFromApi.yes
              ? () {
                  // _publishMessageSend();
                  _publishData();
                }
              : null,
          label: appState.isLoadingSave()
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : Text("Simpan"),
          icon: Icon(Icons.cloud_upload),
          focusColor: Colors.white,
          backgroundColor: appState.getAppConnectionState ==
                      MQTTAppConnectionState.connected &&
                  appState.getMqttSubscribe == MqttSubscribe.yes &&
                  appState.getUserFromApi == UserFromApi.yes
              ? Colors.blue
              : Colors.grey),
    );
  }
}

_displaySnackBar(BuildContext context) {
  final snackBar = SnackBar(content: Text('data tersimpan'));
  Scaffold.of(context).showSnackBar(snackBar);
}
