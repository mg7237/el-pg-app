import 'package:flutter/material.dart';

class CommonMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        openDrawer(context);
      },
    );
  }

  openDrawer(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
    scaffoldState.openDrawer();
  }
}
