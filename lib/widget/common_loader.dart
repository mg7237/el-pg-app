import 'package:flutter/material.dart';

class CommonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: 35,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
