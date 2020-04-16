import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Function onPressed;
  final double fontSize;

  CommonButton({
    @required this.text,
    @required this.bgColor,
    @required this.onPressed,
    fontSize : 18.0,
  }) : this.fontSize = fontSize ?? 18.0;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(14),
      color: bgColor,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
