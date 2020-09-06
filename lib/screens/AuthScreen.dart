import 'dart:math';

import 'package:AN_shop_application/widgets/AuthWidget.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyan, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: AuthWidget(),
      ),
    );
  }
}
