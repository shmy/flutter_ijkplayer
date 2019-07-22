import 'package:flutter/material.dart';
import 'package:ijkplayer/ijk_default_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String url = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        children: <Widget>[
          IjkDefaultPlayer(
            url: url,
            title: "测试",
          ),
//          IjkDefaultPlayer(
//            url: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
//            title: "测试",
//          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                url = "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
              });
            },
            child: Text("set mp4"),
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                url = "https://eth.ppzuida.com/20190709/5873_e2600d88/index.m3u8";
              });
            },
            child: Text("set m3u8"),
          ),
        ],
      ),
    );
  }
}
