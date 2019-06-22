import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const CHANNEL_NAME = "tech.shmy.ijkplayer";

Widget buildIconButton(IconData icon) {
  return Padding(
    padding: EdgeInsets.only(
      left: 7.0,
      right: 7.0,
    ),
    child: Icon(
      icon,
      color: Colors.white,
      size: 20.0,
    ),
  );
}

void back(BuildContext context) async {
  await SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown]);
  Navigator.of(context).pop();
}