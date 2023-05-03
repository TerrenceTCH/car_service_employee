import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:car_days_employee/homePage.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'MechanicDetectionResult.dart';

class MechanicDetection extends StatefulWidget {
  const MechanicDetection({Key? key}) : super(key: key);

  @override
  State<MechanicDetection> createState() => _MechanicDetectionState();
}

class _MechanicDetectionState extends State<MechanicDetection> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  final _textRecognizer = TextRecognizer();
  late final Future<void> _future;
  CameraController? _cameraController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              if (_isPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _initCameraController(snapshot.data!);

                        return Center(child: CameraPreview(_cameraController!));
                      } else {
                        return const LinearProgressIndicator();
                      }
                    }),
              Scaffold(
                  backgroundColor: _isPermissionGranted ? Colors.transparent : null,
                  body: _isPermissionGranted? Column(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        padding:  EdgeInsets.only(bottom: 55.0),
                        child:  Center(
                          child: ElevatedButton(
                            onPressed: _scanImage,
                            child: Text(
                              'Scan Car Plate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white24, // Replace with your desired color
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                      : Center(
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24.0),
                        child: const Text(
                          'Camera Permission Denied',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white
                          ),
                        )),
                  )
              ),
            ],
          );
        });
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);

    await _cameraController?.initialize();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _scanImage() async
  {
    if(_cameraController == null)
    {
      return;
    }
    print('im here');

    final navigator = Navigator.of(context);

    try
    {
      final pictureFile = await _cameraController!.takePicture();
      final file = File(pictureFile.path);
      final inputImage = InputImage.fromFile(file);
      //final List<DetectedObject> detectedObjects = await objectDetector.processImage(inputImage);
      // for(final object in detectedObjects){
      //   print(object.labels.first.text);
      // }
      // Rect carPlateBox;
      // for (final object in detectedObjects) {
      //   final objectCategory = object.labels.first.text;
      //   print(objectCategory);
      //   if (objectCategory == 'car plate') {
      //     // The object is a car plate.
      //     carPlateBox = object.boundingBox;
      //     print(carPlateBox.height);
      //     print(carPlateBox.width);
      //     break;
      //   }
      // }
      final recognizedText = await _textRecognizer.processImage(inputImage);
      String combinedString = '';
      for(TextBlock textblock in recognizedText.blocks){
        for (TextLine line in textblock.lines) {
          for (TextElement element in line.elements) {
            combinedString += element.text + ' '; // Add space separator between elements
          }
        }
      }
      await navigator.push(MaterialPageRoute(builder: (context) => MechanicDetectionResult(text: combinedString)));
    }
    catch(e)
    {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('An error occured when scanning!')));
    }
  }
}
