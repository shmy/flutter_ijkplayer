import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ijkplayer/core/ijk_controller.dart';
import 'package:ijkplayer/core/ijk_defs.dart';

typedef void IjkPlayerCreatedCallback(IjkController controller);

// 默认播放器
class IjkPlayer extends StatefulWidget {
  IjkPlayer({
    Key key,
    @required this.controller,
    this.isFullscreen = false,
    this.isLocked = false,
    this.ijkControlsHeader,
    this.ijkControlsFooter,
    this.ijkControlsBuffering,
  }) : super(key: key);

  final IjkController controller;
  final bool isFullscreen;
  bool isLocked;
  final Widget ijkControlsHeader;
  final Widget ijkControlsFooter;
  final Widget ijkControlsBuffering;

  @override
  _IjkPlayerState createState() => _IjkPlayerState();
}

class _IjkPlayerState extends State<IjkPlayer> {
  bool showControls = true;

  IjkController get _controller => widget.controller;

  bool get _isFullscreen => widget.isFullscreen;

  bool get _isLocked => widget.isLocked;

  @override
  void initState() {
    _controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    super.dispose();
  }

  @override
  void didUpdateWidget(IjkPlayer oldWidget) {
    if (oldWidget.controller != widget.controller) {
      _controller.addListener(_listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Stack(
      children: <Widget>[
        // Texture
        Positioned.fill(
          child: Container(
            color: Colors.black,
            child: Center(
              child: AspectRatio(
                aspectRatio: widget.controller?.aspectRatio ?? 16 / 9,
                child: _controller?.id != null
                    ? Texture(textureId: _controller.id)
                    : Container(),
              ),
            ),
          ),
        ),
        // 加载层
        Positioned.fill(
          child: _buildLoadingLayer(),
        ),
        // 控制层
        Positioned.fill(child: _buildControllerLayer()),
        // 控件层
        Positioned.fill(
          child:
              showControls && !_isLocked ? _buildControlsLayer() : Container(),
        ),
        // 弹出层
//        Positioned.fill(child: null),
      ],
    );

    if (!_isFullscreen) {
      return child;
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: child,
    );
  }

  Widget _buildLoadingLayer() {
    return Center(
      child: widget.ijkControlsBuffering ?? Container(),
    );
  }

  Widget _buildControllerLayer() {
    return GestureDetector(
      onDoubleTap: _switchPlayState,
      onTap: _switchControls,
      child: Container(
        color: Colors.transparent,
        child: showControls
            ? Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 20.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isLocked = !widget.isLocked;
                        });
                      },
                      child: Icon(
                        _isLocked ? Icons.lock : Icons.lock_open,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _buildControlsLayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        widget.ijkControlsHeader ?? Container(),
        widget.ijkControlsFooter ?? Container(),
      ],
    );
  }

  Future<bool> _onWillPop() {
    back(context);
    return Future.value(false);
  }

  void _listener() {
    if (mounted) {
      setState(() {});
    }
  }

  void _switchPlayState() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _switchControls() {
    setState(() {
      showControls = !showControls;
    });
  }
}
