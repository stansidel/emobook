import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'drawn_line.dart';
import 'sketcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawingPageImageData {
  final String extension;
  final Uint8List data;

  const DrawingPageImageData({required this.extension, required this.data});
}

class DrawingPage extends StatefulWidget {
  static const routeName = '/drawing';

  const DrawingPage({Key? key}) : super(key: key);

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final _globalKey = GlobalKey();
  List<DrawnLine> lines = <DrawnLine>[];
  DrawnLine? line;
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;

  StreamController<List<DrawnLine>> linesStreamController =
      StreamController<List<DrawnLine>>.broadcast();
  StreamController<DrawnLine> currentLineStreamController =
      StreamController<DrawnLine>.broadcast();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        try {
          final bytes = await getImageBytes();
          if (bytes != null) {
            Navigator.pop(
                context, DrawingPageImageData(data: bytes, extension: 'png'));
          }
        } catch (e) {
          log('Unable to pass the image back. Error: $e');
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.drawingPage_title),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildAllPaths(context),
            _buildCurrentPath(context),
            _buildStrokeToolbar(),
            _buildColorToolbar(),
          ],
        ),
      ),
    );
  }

  Future<void> saveToGallery() async {
    try {
      final pngBytes = await getImageBytes();
      if (pngBytes == null) {
        return;
      }
      var saved = await ImageGallerySaver.saveImage(
        pngBytes,
        quality: 100,
        name: DateTime.now().toIso8601String() + ".png",
        isReturnImagePathOfIOS: true,
      );
      log('Saved: $saved');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Uint8List?> getImageBytes() async {
    final boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }
    ui.Image image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      return null;
    }
    Uint8List pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  Future<void> clear() async {
    setState(() {
      lines = [];
      line = null;
    });
  }

  Widget _buildCurrentPath(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: RepaintBoundary(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(4.0),
          color: Colors.transparent,
          alignment: Alignment.topLeft,
          child: StreamBuilder<DrawnLine>(
            stream: currentLineStreamController.stream,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: Sketcher(
                  lines: [if (line != null) line!],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAllPaths(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        padding: const EdgeInsets.all(4.0),
        alignment: Alignment.topLeft,
        child: StreamBuilder<List<DrawnLine>>(
          stream: linesStreamController.stream,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: Sketcher(
                lines: lines,
              ),
            );
          },
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    final box = _globalKey.currentContext?.findRenderObject();
    if (box is! RenderBox) {
      return;
    }
    Offset point = box.globalToLocal(details.globalPosition);
    line = DrawnLine([point], selectedColor, selectedWidth);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = _globalKey.currentContext?.findRenderObject();
    if (box is! RenderBox) {
      return;
    }
    Offset point = box.globalToLocal(details.globalPosition);

    final line = this.line;
    if (line == null) {
      return;
    }

    List<Offset> path = List.from(line.path)..add(point);
    this.line = DrawnLine(path, selectedColor, selectedWidth);
    currentLineStreamController.add(line);
  }

  void _onPanEnd(DragEndDetails details) {
    final line = this.line;
    if (line == null) {
      return;
    }

    lines = List.from(lines)..add(line);

    linesStreamController.add(lines);
  }

  Widget _buildStrokeToolbar() {
    return Positioned(
      bottom: 10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStrokeButton(5.0),
          _buildStrokeButton(10.0),
          _buildStrokeButton(15.0),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(double strokeWidth) {
    final containerWidth = math.max(strokeWidth * 2, 38.0);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWidth = strokeWidth;
        });
      },
      child: SizedBox(
        width: containerWidth,
        height: containerWidth,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: strokeWidth * 2,
              height: strokeWidth * 2,
              decoration: BoxDecoration(
                  color: selectedColor, borderRadius: BorderRadius.circular(50.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar() {
    return Positioned(
      top: 40.0,
      right: 10.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildClearButton(),
          const Divider(
            height: 10.0,
          ),
          // buildSaveButton(),
          // Divider(
          //   height: 20.0,
          // ),
          _buildColorButton(Colors.red),
          _buildColorButton(Colors.blueAccent),
          _buildColorButton(Colors.deepOrange),
          _buildColorButton(Colors.green),
          _buildColorButton(Colors.lightBlue),
          _buildColorButton(Colors.black),
          _buildColorButton(Colors.white),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FloatingActionButton(
        heroTag: null,
        mini: true,
        backgroundColor: color,
        child: Container(),
        onPressed: () {
          setState(() {
            selectedColor = color;
          });
        },
      ),
    );
  }

  // Widget _buildSaveButton() {
  //   return GestureDetector(
  //     onTap: saveToGallery,
  //     child: const CircleAvatar(
  //       child: Icon(
  //         Icons.save,
  //         size: 20.0,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: clear,
      child: const CircleAvatar(
        child: Icon(
          Icons.delete,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
