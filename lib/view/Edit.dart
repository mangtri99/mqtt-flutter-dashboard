import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Edit extends StatefulWidget {
  final value;

  Edit({Key key, @required this.value}) : super(key: key);
  @override
  _EditState createState() => _EditState(value: value);
}

class _EditState extends State<Edit> {
  _EditState({@required this.value}) : super();

  final value;
  TextEditingController _topicController = TextEditingController();

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var topic = preferences.getString(widget.value);

    setState(() {
      _topicController.text = topic;
    });
    // if (value != null) {
    //   setState(() {
    //     _topicController.text = value;
    //   });
    // }
  }

  saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(widget.value, _topicController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print(widget.value);
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _topicController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Panel'),
        backgroundColor: Colors.blue,
      ),
      body: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: _topicController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Masukan Topic Suhu',
                    contentPadding: EdgeInsets.only(left: 10.0)),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 50,
                    child: FlatButton(
                      onPressed: () {
                        saveData();
                        _displaySnackBar(context);
                        FocusScope.of(context).unfocus();
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(fontSize: 16),
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

_displaySnackBar(BuildContext context) {
  final snackBar = SnackBar(content: Text('Berhasil Disimpan'));
  Scaffold.of(context).showSnackBar(snackBar);
}
