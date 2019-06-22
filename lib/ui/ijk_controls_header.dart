import 'package:flutter/material.dart';
import 'package:ijkplayer/core/ijk_controller.dart';
import 'package:ijkplayer/core/ijk_defs.dart';

class IjkControlsHeader extends StatefulWidget {
  IjkControlsHeader(
      {Key key,
      @required this.controller,
      this.title = "",
      this.showBackButton = true})
      : super(key: key);
  final IjkController controller;
  final String title;
  final bool showBackButton;

  @override
  _IjkControlsHeaderState createState() => _IjkControlsHeaderState();
}

class _IjkControlsHeaderState extends State<IjkControlsHeader> {
  IjkController get _ijkController => widget.controller;

  String get _title => widget.title;

  bool get _showBackButton => widget.showBackButton;
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
  void didUpdateWidget(IjkControlsHeader oldWidget) {
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
          Expanded(
            child: Row(
              children: <Widget>[
                _showBackButton
                    ? GestureDetector(
                        onTap: () => back(context),
                        child: buildIconButton(
                          Icons.arrow_back_ios,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Text(
                    _title,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
