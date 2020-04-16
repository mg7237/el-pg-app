import 'package:flutter/material.dart';

class LabelTextAstric extends StatelessWidget {
  final String text;

  LabelTextAstric(this.text);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14)
          ),
          TextSpan(
            text: '*',
            style: TextStyle(
              color: Colors.red
            )
          )
        ]
      ),
    );
  }
}
