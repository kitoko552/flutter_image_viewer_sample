import 'package:flutter/material.dart';

import 'fade_in_route.dart';
import 'image_viewer.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedAsset = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Viewer Sample')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: Column(
            children: [
              _buildImage('assets/karuizawa.jpg'),
              _spacer(16.0),
              _buildImage('assets/alpaca.jpg'),
              _spacer(16.0),
              _buildImage('assets/jack-jack.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String name) {
    return Opacity(
      opacity: (name == _selectedAsset) ? 0.0 : 1.0,
      child: InkWell(
        child: Hero(
          tag: name,
          child: Image.asset(name),
        ),
        onTap: () {
          Navigator.of(context).push(
            FadeInRoute(
              widget: ImageViewerPage(name),
              opaque: false,
              onTransitionCompleted: () {
                setState(() {
                  _selectedAsset = name;
                });
              },
              onTransitionDismissed: () {
                setState(() {
                  _selectedAsset = '';
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _spacer(double height) {
    return Container(height: height);
  }
}
