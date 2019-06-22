import 'package:flutter/material.dart';
import 'package:ijkplayer_example/video.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MyAppTestPage()
    );
  }

}

class MyAppTestPage extends StatefulWidget {
  @override
  _MyAppTestPageState createState() => _MyAppTestPageState();
}

class _MyAppTestPageState extends State<MyAppTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => VideoPage()));
            },
            child: Text('gogo'),
          )
        ],
      ),
    );
  }
}


