import 'dart:math';
import 'package:flutter/material.dart';

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  Color _color = Colors.black45;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings = context
        .dependOnInheritedWidgetOfExactType(aspect: FlexibleSpaceBarSettings);
    // bool visible =
    //     settings == null || settings.currentExtent <= settings.minExtent;
    setState(() {
      if (settings == null) {
        _color = _color.withOpacity(0);
      } else {
        _color = _color.withOpacity(Colors.black87.opacity *
            (1 - (settings.minExtent / settings.currentExtent)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      color: _color,
      //color: !_visible ? Colors.black45 : Color.fromRGBO(0, 0, 0, 0),
    );
  }
}
