import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String text;

  LabelText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
    );
  }
}
