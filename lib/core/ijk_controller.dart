import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:ijkplayer/core/ijk_defs.dart';
import 'package:ijkplayer/core/ijk_value.dart';

final MethodChannel _methodChannel = new MethodChannel('$CHANNEL_NAME/method');
//final EventChannel _eventChannel = new EventChannel('$CHANNEL_NAME/event');

class IjkController extends ValueNotifier<IjkValue> {
  int id;
  StreamSubscription<dynamic> _eventSubscription;
  bool _isDisposed = false;
  String dataSource;
  EventChannel _eventChannel;
  IjkController.network(this.dataSource) : super(IjkValue());

  Future<void> initialize() async {
    var _id = await _methodChannel.invokeMethod("init", dataSource);
    _isDisposed = false;
    id = _id;
    _eventChannel = new EventChannel('$CHANNEL_NAME/$id');
    _eventSubscription = _eventChannel.receiveBroadcastStream().listen((data) {
      double width = (data["width"] as int).toDouble();
      double height = (data["height"] as int).toDouble();
      value = value.copyWith(
        initialized: data["initialized"],
        isCompleted: data["isCompleted"],
        isBuffering: data["isBuffering"],
        isPlaying: data["isPlaying"],
        bufferingProgress: data["bufferingProgress"],
        netWorkSpeed: data["netWorkSpeed"],
        duration: data["duration"],
        position: data["position"],
        size: Size(width, height),
        errorCode: data["errorCode"],
      );
    });
  }

  double get aspectRatio => (value.size.width / value.size.height) ?? 1.33;

  @override
  Future<void> dispose() async {
    if (!_isDisposed) {
      await _eventSubscription?.cancel();
      await _methodChannel.invokeMethod('dispose', id);
      _isDisposed = true;
    }
    super.dispose();
  }

  Future<void> pause() async {
    return _methodChannel.invokeMethod('pause', id);
  }

  Future<void> play() async {
    return _methodChannel.invokeMethod('play', id);
  }

  Future<void> stop() async {
    return _methodChannel.invokeMethod('stop', id);
  }

  Future<void> seekTo(int position) async {
    return _methodChannel.invokeMethod('seekTo', {
      "position": position,
      "id": id,
    });
  }
}
