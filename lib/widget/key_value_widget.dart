import 'package:flutter/material.dart';

class KeyValueView extends StatelessWidget {
  final String type;
  final String value;

  KeyValueView({@required this.type, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          type,
          style: TextStyle(color: Colors.pink, fontSize: 10),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
              color: Colors.grey[700], fontSize: 10),
        )
      ],
    );
  }
}
