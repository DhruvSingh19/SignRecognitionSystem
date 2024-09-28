import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class signRecognizePage extends StatefulWidget {
  const signRecognizePage({super.key});

  @override
  State<signRecognizePage> createState() => _signRecognizePageState();
}

class _signRecognizePageState extends State<signRecognizePage> {
  bool _isCameraRunning = false;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  File? _image;
  String _label = "No result";
  String _confidence = "N/A";
  bool _isRecognitionActive = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadModel();
  }


  Future<void> _loadModel() async{
    String? res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
  }

  Future<void> _disposeModel() async{
    await Tflite.close();
  }

  Future<void> _recognizeFromGallery(String filepath) async{
    var recognitions = await Tflite.runModelOnImage(
        path: filepath,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true      // defaults to true
    );
    _updateRecognitionResult(recognitions);
  }

  Future<void> _recognizeFromCamera(CameraImage img) async{
    _isRecognitionActive = true;
    var recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) {return plane.bytes;}).toList(),// required
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,   // defaults to 127.5
        imageStd: 127.5,    // defaults to 127.5
        rotation: 90,       // defaults to 90, Android only
        numResults: 2,      // defaults to 5
        threshold: 0.1,     // defaults to 0.1
        asynch: true        // defaults to true
    );
    if(_isRecognitionActive) {
      _updateRecognitionResult(recognitions);
    }
  }

  void _updateRecognitionResult(List<dynamic>? recognitions) {
    if (recognitions != null && recognitions.isNotEmpty) {
      setState(() {
        _label = recognitions[0]['label'];
        _confidence = (recognitions[0]['confidence'] * 100.0).toStringAsFixed(2) + "%";
      });
    } else {
      setState(() {
        _label = "No result";
        _confidence = "N/A";
      });
    }
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      // Get the list of available cameras
      _cameras = await availableCameras();

      if (_cameras!.isNotEmpty) {
        // Initialize the camera controller with the first camera
        _cameraController = CameraController(
          _cameras![0], // Using the first available camera
          ResolutionPreset.high,
        );

        // Initialize the controller
        await _cameraController?.initialize();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission denied")),
      );
    }
  }

  void _startCamera() async {
    if (_cameraController != null &&
        !_cameraController!.value.isStreamingImages) {
      await _cameraController!.startImageStream((image) async {
        await _recognizeFromCamera(image);
      });
      setState(() {
        _image = null;
        _isCameraRunning = true;
      });
    }
  }

  void _stopCamera() async {
    if (_cameraController != null &&
        _cameraController!.value.isStreamingImages) {
      _isRecognitionActive = false;
      await _cameraController!.stopImageStream();
        setState(() {
          _isCameraRunning = false;
          _label = "No result";
          _confidence = "N/A";
        });
    }
  }

  void _toggleCamera() {
    if (_isCameraRunning) {
      _stopCamera();
    } else {
      _startCamera();
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() async {
        _image = File(image.path);
        _stopCamera();
        await _recognizeFromGallery(image.path);
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _disposeModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Center(
              child: Container(
            height: 350,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: _image == null
                ? Stack(
                    children: [
                      _isCameraRunning
                          ? SizedBox(
                              width: 350,
                              height: 350,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _cameraController!
                                      .value.previewSize!.width,
                                  height: _cameraController!
                                      .value.previewSize!.height,
                                  child: CameraPreview(_cameraController!),
                                ),
                              ),
                            )
                          : const Center(
                              child: Text(
                                "No camera/image selected",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      if (_isCameraRunning) // Only include this widget when the camera is running
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: _toggleCamera,
                              child: const Text(
                                "Stop Camera",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Placeholder color
                      borderRadius: BorderRadius.circular(10),
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit
                                  .cover, // Makes the image cover the entire container
                            )
                          : null,
                    ),
                  ),
          )),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: _startCamera,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    !_isCameraRunning? Colors.grey.shade800: Colors.grey.shade900, // Set background color to grey
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: Text(
                    "Start Camera",
                    style: TextStyle(color:!_isCameraRunning? Colors.white: Colors.grey.shade700),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.grey.shade800, // Set background color to grey
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  child: const Text(
                    "Pick form Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ]),

          const SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Label",style: TextStyle(color: Colors.white),)),
                      Align(
                        alignment: Alignment.center,
                        child: Text(_label, style: TextStyle(color: Colors.white),),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(
                width: 20,
              ),

              Container(
                height: 70,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Confidence",style: TextStyle(color: Colors.white),)),
                      Align(
                        alignment: Alignment.center,
                        child: Text(_confidence, style: TextStyle(color: Colors.white),),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
