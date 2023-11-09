import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:printer/form.dart';

class Scanner extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Scanner({Key? key, required this.cameras}) : super(key: key);
  @override
  _Scanner createState() => _Scanner();
}

class _Scanner extends State<Scanner> {
  late CameraController camController;
  late Future<void> initControlerFuture;
  late String imagePath;

  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();

    camController = CameraController(
      widget.cameras[0],
      ResolutionPreset.veryHigh,
    );
    initControlerFuture = camController.initialize();
  }

  Future<String?> captureImage() async {
    try {
      final image = await camController.takePicture();
      imagePath = image.path;
      final RecognizedText recognizedText =
          await textRecognizer.processImage(InputImage.fromFilePath(imagePath));

      String? plateNum;
      RegExp regex = RegExp(r'[A-Z]{3} \d{3,4}');
      for (TextBlock block in recognizedText.blocks) {
        final String text = block.text;
        plateNum = regex.stringMatch(text);

        if (plateNum != null) {
          debugPrint("Found: $plateNum");
          return plateNum;
        }

        debugPrint(text);
      }
    } catch (e) {
      debugPrint('Error Occured!: $e');
    }
    return null;
  }

  @override
  void dispose() {
    camController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    const ButtonStyle bStyle = ButtonStyle(
      iconColor:
          MaterialStatePropertyAll<Color>(Color.fromARGB(255, 26, 152, 255)),
      backgroundColor:
          MaterialStatePropertyAll<Color>(Color.fromARGB(255, 41, 41, 41)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        title: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(),
                color: const Color.fromARGB(255, 26, 152, 255)),
            child: const Text(
              'EDakop',
              style: TextStyle(
                  fontFamily: 'Helvetica', color: Color.fromARGB(255, 0, 0, 0)),
            )),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: initControlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  width: scrWidth,
                  height: scrHeight,
                  child: AspectRatio(
                    aspectRatio: camController.value.aspectRatio,
                    child: CameraPreview(camController),
                  ),
                ),
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            style: bStyle,
                            onPressed: () {
                              captureImage().then((plateNumStr) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TicketForm(
                                              data: plateNumStr,
                                            )));
                              });
                            },
                            icon: const Icon(Icons.image),
                            label: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(),
                                    color: const Color.fromARGB(
                                        255, 26, 152, 255)),
                                child: const Text(
                                  'Scan Licence Plate',
                                  style: TextStyle(
                                      fontFamily: 'Helvetica',
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
