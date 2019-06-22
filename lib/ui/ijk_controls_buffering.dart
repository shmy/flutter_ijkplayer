import 'package:flutter/material.dart';
import 'package:ijkplayer/core/ijk_controller.dart';

class IjkControlsBuffering extends StatefulWidget {
  IjkControlsBuffering({
    Key key,
    @required this.controller,
  }) : super(key: key);
  final IjkController controller;

  @override
  _IjkControlsBufferingState createState() => _IjkControlsBufferingState();
}

class _IjkControlsBufferingState extends State<IjkControlsBuffering> {
  IjkController get _ijkController => widget.controller;

  bool get _isBuffering {
    bool isBuffering = _ijkController?.value?.isBuffering;
    if (isBuffering == null) {
      return true;
    }
    return isBuffering;
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
  void didUpdateWidget(IjkControlsBuffering oldWidget) {
    if (oldWidget.controller != widget.controller) {
      _ijkController.addListener(_listener);
    }
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    return _isBuffering
        ? Container(
            height: 45.0,
            width: 45.0,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      (_ijkController?.value?.bufferingProgress?.toString() ??
                              "0") +
                          "%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
