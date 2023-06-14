// Author: Pham (Sky) Truong
// Description: First page to load up
// Last revised: April 3, 2021

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gettechapp/pages/sign_in_page.dart';
import 'package:gettechapp/pages/sign_up_page.dart';

class StartUpPage extends StatefulWidget {
  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double bigMultiplier = 10;
    double smallMultiplier = 3;

    return Scaffold(
      body: initScreen(bigMultiplier, unitHeightValue, smallMultiplier),
    );
  }

  startTime() async {
    var duration = Duration(seconds: 2);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  }

  Stack initScreen(
      double bigMultiplier, double unitHeightValue, double smallMultiplier) {
    return Stack(
      children: [
        StartUpBackground(),
        _buildStartUpBody(
            bigMultiplier: bigMultiplier,
            unitHeightValue: unitHeightValue,
            smallMultiplier: smallMultiplier),
      ],
    );
  }
}

class _buildStartUpBody extends StatelessWidget {
  const _buildStartUpBody({
    Key? key,
    required this.bigMultiplier,
    required this.unitHeightValue,
    required this.smallMultiplier,
  }) : super(key: key);

  final double bigMultiplier;
  final double unitHeightValue;
  final double smallMultiplier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: Center(
            child: Text(
              "getTech",
              style: TextStyle(
                fontSize: bigMultiplier * unitHeightValue,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Text(
            "One hub to find all\navailable hardware near you",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: smallMultiplier * unitHeightValue,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class StartUpBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: StartUpPainter(),
      ),
    );
  }
}

class StartUpPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    var paint = Paint();

    var mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Color.fromRGBO(31, 46, 53, 1.0);
    canvas.drawPath(mainBackground, paint);

    var curvePath = Path();
    curvePath.moveTo(0, height * 0.55);
    curvePath.quadraticBezierTo(width / 2, height / 1.25, width, height * 0.55);
    curvePath.lineTo(width, 0);
    curvePath.lineTo(0, 0);
    paint.color = Color.fromRGBO(255, 197, 66, 1.0);
    canvas.drawPath(curvePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
