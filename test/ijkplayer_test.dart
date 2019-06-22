import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:ijkplayer/ijkplayer.dart';

void main() {
  const MethodChannel channel = MethodChannel('ijkplayer');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

//  test('getPlatformVersion', () async {
//    expect(await Ijkplayer.platformVersion, '42');
//  });
}
