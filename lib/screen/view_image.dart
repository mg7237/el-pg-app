import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  final String url;

  const ViewImage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
          child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.white),
        imageProvider: CachedNetworkImageProvider(url),
      )),
    );
  }
}
