import 'package:flutter/material.dart';
import 'package:ijkplayer/ijk_default_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String url = "https://v3.juhui600.com/20190529/MYXy1dwh/index.m3u8";
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
                url = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";
              });
            },
            child: Text("set m3u8"),
          ),
        ],
      ),
    );
  }
}
