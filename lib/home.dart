import 'package:decetion_object/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
    TextToSpeech.initTts();
  }


  loadModel() async {
    String res;
    res = await Tflite.loadModel(
      model: "assets/yolov2_tiny.tflite",
      labels: "assets/yolov2_tiny.txt",
    );
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: _model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text("Start"),
                    onPressed: () => onSelect('Tiny YOLOv2'),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    results: _recognitions == null ? [] : _recognitions,
                    previewH: math.max(_imageHeight, _imageWidth),
                    previewW: math.min(_imageHeight, _imageWidth),
                    screenH: screen.height,
                    screenW: screen.width,
                    model: _model),
              ],
            ),
      // body: Stack(
      //   children: [
      //     Camera(
      //       widget.cameras,
      //       _model,
      //       setRecognitions,
      //     ),
      //     BndBox(
      //         results: _recognitions == null ? [] : _recognitions,
      //         previewH: math.max(_imageHeight, _imageWidth),
      //         previewW: math.min(_imageHeight, _imageWidth),
      //         screenH: screen.height,
      //         screenW: screen.width,
      //         model: _model),
      //   ],
      // ),
    );
  }
}
