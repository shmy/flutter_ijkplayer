import 'dart:ui';

class IjkValue {
  final bool initialized;
  final bool isBuffering;
  final bool isCompleted;
  final int bufferingProgress;
  final bool isPlaying;
  final int netWorkSpeed;
  final int duration;
  final int position;
  final Size size;
  final int errorCode;

  IjkValue({
    this.initialized,
    this.isBuffering,
    this.isPlaying,
    this.isCompleted,
    this.bufferingProgress,
    this.netWorkSpeed,
    this.duration,
    this.position,
    this.size = const Size(1920, 1080),
    this.errorCode = -1,
  });

  IjkValue copyWith(
      {bool initialized,
      bool isBuffering,
      bool isPlaying,
      bool isCompleted,
      int bufferingProgress,
      int netWorkSpeed,
      int duration,
      int position,
      Size size,
      int errorCode}) {
    return IjkValue(
      initialized: initialized ?? this.initialized,
      isBuffering: isBuffering ?? this.isBuffering,
      isPlaying: isPlaying ?? this.isPlaying,
      isCompleted: isCompleted ?? this.isCompleted,
      bufferingProgress: bufferingProgress ?? this.bufferingProgress,
      netWorkSpeed: netWorkSpeed ?? this.netWorkSpeed,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      size: size ?? this.size,
      errorCode: errorCode ?? this.errorCode,
    );
  }
}
