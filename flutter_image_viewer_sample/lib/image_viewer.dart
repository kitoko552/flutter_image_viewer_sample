import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewerPage extends StatefulWidget {
  ImageViewerPage({
    @required this.assetName,
  });

  final String assetName;

  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  Offset _beginningDragPosition = Offset.zero;
  Offset _currentDragPosition = Offset.zero;
  PhotoViewScaleState scaleState = PhotoViewScaleState.initial;
  int _photoViewAnimationDurationMilliSec = 0;
  double _barsOpacity = 0.0;

  double get _photoViewScale {
    return max(
      1.0 - _currentDragPosition.distance * 0.001,
      0.8,
    );
  }

  double get _photoViewOpacity {
    return max(
      1.0 - _currentDragPosition.distance * 0.005,
      0.1,
    );
  }

  Matrix4 get _photoViewTransform {
    final translationTransform = Matrix4.translationValues(
      _currentDragPosition.dx,
      _currentDragPosition.dy,
      0.0,
    );

    final scaleTransform = Matrix4.diagonal3Values(
      _photoViewScale,
      _photoViewScale,
      1.0,
    );

    return translationTransform * scaleTransform;
  }

  void onTapPhotoView() {
    setState(() {
      _barsOpacity = (_barsOpacity <= 0.0) ? 1.0 : 0.0;
    });
  }

  void onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _barsOpacity = 0.0;
      _photoViewAnimationDurationMilliSec = 0;
    });
    _beginningDragPosition = details.globalPosition;
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _barsOpacity = (_currentDragPosition.distance < 20.0) ? 1.0 : 0.0;
      _currentDragPosition = Offset(
        details.globalPosition.dx - _beginningDragPosition.dx,
        details.globalPosition.dy - _beginningDragPosition.dy,
      );
    });
  }

  void onVerticalDragEnd(DragEndDetails details) {
    if (_currentDragPosition.distance < 100.0) {
      setState(() {
        _photoViewAnimationDurationMilliSec = 200;
        _currentDragPosition = Offset.zero;
        _barsOpacity = 1.0;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    // run topBar animation after the transition are finished
    Future.delayed(
      Duration(milliseconds: 400),
      () => setState(() => _barsOpacity = 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            _buildImage(context),
            _buildTopBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: onTapPhotoView,
      onVerticalDragStart: scaleState == PhotoViewScaleState.initial
          ? onVerticalDragStart
          : null,
      onVerticalDragUpdate: scaleState == PhotoViewScaleState.initial
          ? onVerticalDragUpdate
          : null,
      onVerticalDragEnd:
          scaleState == PhotoViewScaleState.initial ? onVerticalDragEnd : null,
      child: Container(
        color: Colors.black.withOpacity(_photoViewOpacity),
        child: AnimatedContainer(
          duration: Duration(milliseconds: _photoViewAnimationDurationMilliSec),
          transform: _photoViewTransform,
          child: PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
            imageProvider: AssetImage(widget.assetName),
            heroTag: widget.assetName,
            minScale: PhotoViewComputedScale.contained,
            scaleStateChangedCallback: (state) {
              setState(() {
                scaleState = state;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double topBarHeight = 64.0;
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: _barsOpacity,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        height: topBarHeight,
        child: Column(
          children: [
            Container(height: statusBarHeight),
            Container(
              height: topBarHeight - statusBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(width: 8.0),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
