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
  // TextEditingController _topicSendController = TextEditingController();
  // TextEditingController _topicSaveController = TextEditingController();

  MqttAppState appState;
  MQTTManager manager;

  saveSetting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var _broker = _brokerController.text;
    var _topicMain = _topicController.text;

    await preferences.setString('broker', _broker);
    await preferences.setString('topicMain', _topicMain);

    // await preferences.setString('topicSave', _topicSaveController.text);
    // await preferences.setString('topicSend', _topicSendController.text);
  }

  getSetting() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var _getBroker = preferences.getString('broker');
    var _getTopicMain = preferences.getString('topicMain');
    // var _getTopicSave = preferences.getString('topicSave');
    // var _getTopicSend = preferences.getString('topicSend');

    if (_getBroker != null && _getTopicMain != null) {
      setState(() {
        _brokerController.text = _getBroker;
        _topicController.text = _getTopicMain;
        // _topicSaveController.text = _getTopicSave;
        // _topicSendController.text = _getTopicSend;
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
    // _topicSaveController.dispose();
    // _topicSendController.dispose();
    super.dispose();
  }

  void check() {
    print('not work');
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
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    color: appState.getAppConnectionState ==
                            MQTTAppConnectionState.disconnect
                        ? Colors.deepOrange
                        : Colors.green,
                    child: Center(
                        child: Text(
                            _statusConnection(appState.getAppConnectionState))),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            _buildTextField(_brokerController, 'Alamat Broker',
                appState.getAppConnectionState),
            SizedBox(
              height: 10.0,
            ),
            _buildTextField(_topicController, 'Topic Subscribe (Wildcard)',
                appState.getAppConnectionState),
            SizedBox(
              height: 10.0,
            ),
            // _buildTextField(_topicSendController, 'Topic Publish (btn Send)',
            //     appState.getAppConnectionState),
            // SizedBox(
            //   height: 10.0,
            // ),
            // _buildTextField(_topicSaveController, 'Topic Publish (btn Save)',
            //     appState.getAppConnectionState),
            // SizedBox(
            //   height: 20.0,
            // ),
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
          ],
        ),
      );
    });
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool enable = false;
    if ((controller == _brokerController &&
            state == MQTTAppConnectionState.disconnect) ||
        (controller == _topicController &&
            state == MQTTAppConnectionState.disconnect)) {
      enable = true;
    }
    return TextFormField(
      enabled: enable,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hintText,
          contentPadding: EdgeInsets.only(left: 10.0)),
    );
  }
}

_displaySnackBar(BuildContext context) {
  final snackBar = SnackBar(content: Text('Berhasil Disimpan'));
  Scaffold.of(context).showSnackBar(snackBar);
}

// _displayStatusConnection(BuildContext context) {
//   final snackBarStatus =
//       SnackBar(content: Text('Disconnect untuk mengubah setting'));
//   Scaffold.of(context).showSnackBar(snackBarStatus);
// }
