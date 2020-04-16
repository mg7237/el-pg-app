import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AttachmentView extends StatelessWidget {
  final Function onPressed;

  AttachmentView({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: DottedBorder(
        color: Colors.grey[400],
        gap: 3,
        strokeWidth: 1,
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Icon(Icons.attach_file),
          ),
        ),
      ),
    );
  }
}