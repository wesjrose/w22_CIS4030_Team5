import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight;

  CustomAppBar({Key? key, required this.preferredHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double titleMultiplier = 6;

    return AppBar(
      backgroundColor: Color.fromRGBO(255, 197, 66, 1.0),
      centerTitle: true,
      title: Text(
        'getTech',
        style: TextStyle(
            fontSize: titleMultiplier * unitHeightValue,
            color: Color.fromRGBO(66, 123, 255, 1.0),
            fontWeight: FontWeight.w600),
      ),
      toolbarHeight: screenHeight / 6,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.vertical(
          bottom: new Radius.elliptical(screenWidth, 90.0),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);
}
