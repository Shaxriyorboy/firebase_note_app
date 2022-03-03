import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  String? url;

  ImagePage({Key? key, this.url}) : super(key: key);
  static const String id = "image_page";

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 2,
          child: Image(
            image: NetworkImage(widget.url!),
          ),
        ),
      ),
    );
  }
}
