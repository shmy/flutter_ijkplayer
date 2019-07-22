import 'package:flutter/material.dart';
import 'package:ijkplayer/ui/ijk_controls_buffering.dart';
import 'package:ijkplayer/ui/ijk_controls_footer.dart';
import 'package:ijkplayer/ui/ijk_controls_header.dart';
import 'package:ijkplayer/core/ijk_player.dart';
import 'package:ijkplayer/core/ijk_controller.dart';

export 'package:ijkplayer/core/ijk_controller.dart';

class IjkDefaultPlayer extends StatefulWidget {
  IjkDefaultPlayer({
    Key key,
    @required this.url,
    this.title = "",
    this.listener,
  }) : super(key: key);
  final String url;
  final String title;
  final Function listener;

  @override
  _IjkDefaultPlayerState createState() => _IjkDefaultPlayerState();
}

class _IjkDefaultPlayerState extends State<IjkDefaultPlayer> {
  IjkController ijkController;

  @override
  void initState() {
    _initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    ijkController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IjkDefaultPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _initPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ijkController != null
          ? IjkPlayer(
              controller: ijkController,
              ijkControlsHeader: IjkControlsHeader(
                title: widget.title,
                controller: ijkController,
              ),
              ijkControlsFooter: IjkControlsFooter(
                controller: ijkController,
                fullscreenWidget: Scaffold(
                  body: IjkPlayer(
                    controller: ijkController,
                    isFullscreen: true,
                    ijkControlsHeader: IjkControlsHeader(
                      title: widget.title,
                      controller: ijkController,
                    ),
                    ijkControlsFooter: IjkControlsFooter(
                      controller: ijkController,
                    ),
                    ijkControlsBuffering: IjkControlsBuffering(
                      controller: ijkController,
                    ),
                  ),
                ),
              ),
              ijkControlsBuffering: IjkControlsBuffering(
                controller: ijkController,
              ),
            )
          : Container(
              color: Colors.black,
            ),
    );
  }

  void _initPlayer() async {
    if (widget.url == null || widget.url.isEmpty) {
      return;
    }
    if (ijkController != null) {
      ijkController.pause();
      ijkController.dispose();
    }
    ijkController = new IjkController.network(widget.url)..initialize();
    ijkController.addListener(() {
      if (widget.listener != null) {
        widget.listener(ijkController);
      }
    });
  }
}
