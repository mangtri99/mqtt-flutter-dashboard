import 'package:flutter/material.dart';
import 'package:mqtt_iot/controller/MqttProvider.dart';
import 'package:mqtt_iot/view/Home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MqttAppState(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Client MQTT',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: Home()),
    );
  }
}
