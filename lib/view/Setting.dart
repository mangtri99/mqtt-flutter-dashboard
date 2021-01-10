import 'package:flutter/material.dart';
import 'package:mqtt_iot/controller/MqttManager.dart';
import 'package:mqtt_iot/controller/MqttProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  TextEditingController _brokerController = TextEditingController();
  TextEditingController _topicController = TextEditingController();
  TextEditingController _topicSendController = TextEditingController();
  TextEditingController _topicSaveController = TextEditingController();

  MqttAppState appState;
  MQTTManager manager;

  saveSetting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var _broker = _brokerController.text;
    var _topicMain = _topicController.text;

    await preferences.setString('broker', _broker);
    await preferences.setString('topicMain', _topicMain);

    await preferences.setString('topicSave', _topicSaveController.text);
    await preferences.setString('topicSend', _topicSendController.text);
  }

  getSetting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var _getBroker = preferences.getString('broker');
    var _getTopicMain = preferences.getString('topicMain');

    if (_getBroker != null && _getTopicMain != null) {
      setState(() {
        _brokerController.text = _getBroker;
        _topicController.text = _getTopicMain;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSetting();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _brokerController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  void configureConnection() {
    manager = MQTTManager(
        host: _brokerController.text,
        topicMain: _topicController.text,
        appState: appState);
  }

  void disconnect() {
    manager.disconnect();
  }

  void publishMessage(String text) {
    final String message = text;
    manager.publish(message);
  }

  String _statusConnection(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnect:
        return 'Disconnected';
    }
  }

  @override
  Widget build(BuildContext context) {
    final MqttAppState appStateX = Provider.of<MqttAppState>(context);
    appState = appStateX;
    final Scaffold scaffold = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
    return scaffold;
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Setting'),
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildBody() {
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.deepOrange,
                    child:
                        Text(_statusConnection(appState.getAppConnectionState)),
                  ),
                )
              ],
            ),
            _buildTextField(_brokerController, 'Alamat Broker',
                appState.getAppConnectionState),
            SizedBox(
              height: 10.0,
            ),
            _buildTextField(_brokerController, 'Topic Wildcard',
                appState.getAppConnectionState),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  child: FlatButton(
                    onPressed: () {
                      saveSetting();
                      _displaySnackBar(context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 16),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 50,
                  child: FlatButton(
                    onPressed: appState.getAppConnectionState ==
                            MQTTAppConnectionState.disconnect
                        ? configureConnection
                        : null,
                    child: Text(
                      'Connect',
                      style: TextStyle(fontSize: 16),
                    ),
                    color: Colors.blue,
                    textColor: Colors.blue,
                  ),
                ),
                Container(
                  height: 50,
                  child: FlatButton(
                    onPressed: appState.getAppConnectionState ==
                            MQTTAppConnectionState.disconnect
                        ? disconnect
                        : null,
                    child: Text(
                      'Disconnect',
                      style: TextStyle(fontSize: 16),
                    ),
                    color: Colors.blue,
                    textColor: Colors.blue,
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool enable = false;
    if (controller == _topicSendController &&
        state == MQTTAppConnectionState.connected) {
      enable = true;
    } else if ((controller == _topicController &&
            state == MQTTAppConnectionState.disconnect) ||
        (controller == _topicController &&
            state == MQTTAppConnectionState.disconnect)) {
      enable = true;

      return TextFormField(
        enabled: enable,
        controller: _brokerController,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Alamat Broker ',
            contentPadding: EdgeInsets.only(left: 10.0)),
      );
    }
  }
}

_displaySnackBar(BuildContext context) {
  final snackBar = SnackBar(content: Text('Berhasil Disimpan'));
  Scaffold.of(context).showSnackBar(snackBar);
}
