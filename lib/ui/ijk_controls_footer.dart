import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ijkplayer/core/ijk_controller.dart';
import 'package:ijkplayer/core/ijk_defs.dart';
import 'package:ijkplayer/core/ijk_utils.dart';

class IjkControlsFooter extends StatefulWidget {
  IjkControlsFooter({
    Key key,
    @required this.controller,
    this.fullscreenWidget,
  }) : super(key: key);
  final IjkController controller;
  final Widget fullscreenWidget;

  @override
  _IjkControlsFooterState createState() => _IjkControlsFooterState();
}

class _IjkControlsFooterState extends State<IjkControlsFooter> {
  IjkController get _ijkController => widget.controller;

  bool get canFullscreen => widget.fullscreenWidget != null;
  double position = 0.0;

  double get _position {
    double position = _ijkController?.value?.position?.toDouble();
    if (position == null) {
      return 0.0;
    }
    if (position >= _duration) {
      return _duration;
    }
    return position;
  }

  double get _duration {
    double duration = _ijkController?.value?.duration?.toDouble();
    if (duration == null) {
      return 0.0;
    }
    return duration;
  }

  bool get _isPlaying {
    bool _isPlaying = _ijkController?.value?.isPlaying;
    if (_isPlaying == null) {
      return true;
    }
    return _isPlaying;
  }
  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }
  @override
  void initState() {
    _ijkController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _ijkController?.removeListener(_listener);
    super.dispose();
  }

  @override
  void didUpdateWidget(IjkControlsFooter oldWidget) {
    if (oldWidget.controller != widget.controller) {
      _ijkController.addListener(_listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, .3),
      height: 36.0,
      width: double.infinity,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_ijkController == null) {
                return;
              }
              if (_isPlaying) {
                _ijkController.pause();
                return;
              }
              _ijkController.play();
            },
            child: buildIconButton(
              _isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Slider(
                    value: _position,
                    min: 0.0,
                    max: _duration,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white54,
                    onChanged: (double value) {
                      setState(() {
                        _ijkController.seekTo(value.toInt());
                      });
                    },
                  ),
                ),
                _buildTimeLabel(formatTime(_position / 1000)),
                _buildTimeLabel(" / "),
                _buildTimeLabel(formatTime(_duration / 1000)),
              ],
            ),
          ),
          canFullscreen
              ? GestureDetector(
                  onTap: _enterFullScreen,
                  child: _buildIconButton(Icons.fullscreen),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTimeLabel(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.0,
        right: 5.0,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 18.0,
      ),
    );
  }

  void _enterFullScreen() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    // 设置横屏
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft]);
    await Navigator.of(context)
        .push(NoTransitionPageRoute(context: context, builder: (BuildContext context, Widget child) {
      return Scaffold(
        body: widget.fullscreenWidget,
      );
    }));
  }
}
