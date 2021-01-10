import 'package:flutter/material.dart';
import 'package:mqtt_iot/controller/MqttManager.dart';
import 'package:mqtt_iot/controller/MqttProvider.dart';
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
  MqttAppState appState;
  MQTTManager manager;
  var readTopicSuhu = '';
  var readTopicBpm = '';
  var readTopicOksigen = '';
  var readTopicTekanan = '';

  getSavedTopic() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var getTopicBpm = preferences.getString('topicBpm');
    var getTopicSuhu = preferences.getString('topicSuhu');

    var getTopicOksigen = preferences.getString('topicOksigen');
    var getTopicTekanan = preferences.getString('topicTekanan');

    if (getTopicSuhu != null && getTopicBpm != null) {
      setState(() {
        readTopicBpm = getTopicBpm;
        readTopicSuhu = getTopicSuhu;
        readTopicOksigen = getTopicOksigen;
        readTopicTekanan = getTopicTekanan;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSavedTopic();
  }

  final TextEditingController _userController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final MqttAppState appStateX = Provider.of<MqttAppState>(context);
    // appState = appStateX;
    return Consumer<MqttAppState>(
        builder: (context, appState, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Setting()));
                      })
                ],
                title: Text('IoT Medical Dashboard'),
                backgroundColor: Colors.blue,
              ),
              backgroundColor: Colors.grey[50],
              body: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                                controller: _userController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'No User',
                                    contentPadding:
                                        EdgeInsets.only(left: 8.0)))),
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                          height: 48,
                          child: FlatButton(
                            onPressed: () {
                              print("buton clicked");
                            },
                            child: Text(
                              "Send",
                              style: TextStyle(fontSize: 17.0),
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
                          child: Text(
                            "User Information",
                            style: TextStyle(fontSize: 15.0),
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
                                  child: Text(
                                    "No : 2020591",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "Nama : Mang Tri",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [Text("Timestamp")],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.device_thermostat,
                                      color: Colors.red,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Edit(
                                                      value: 'topicSuhu',
                                                    )));
                                        print(readTopicSuhu);
                                      },
                                    )
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    '32.88 *C',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Suhu Tubuh",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "$readTopicSuhu",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        )
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Edit(
                                                      value: 'topicBpm',
                                                    )));
                                        print(readTopicBpm);
                                      },
                                    )
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    '32.88 *C',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Detak Jantung",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "$readTopicBpm",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        )
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.album,
                                      color: Colors.red,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Edit(
                                                      value: 'topicOksigen',
                                                    )));
                                        print(readTopicBpm);
                                      },
                                    )
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    '32.88 *C',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Kadar Oksigen",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "$readTopicOksigen",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        )
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.healing,
                                      color: Colors.red,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.more_vert),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Edit(
                                                      value: 'topicTekanan',
                                                    )));
                                        print(readTopicBpm);
                                      },
                                    )
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    '32.88 *C',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Tekanan Darah",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "$readTopicTekanan",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        )
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
              ),
              floatingActionButton: FloatingActionButton.extended(
                elevation: 50,
                onPressed: null,
                label: Text("Save"),
                icon: Icon(Icons.send),
              ),
            ));
  }
}
