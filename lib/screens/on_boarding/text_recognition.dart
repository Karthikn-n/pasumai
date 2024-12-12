import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognition extends StatefulWidget {
  const TextRecognition({super.key});

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
   String _recognizedText = '';

  Future<void> _pickImageAndRecognizeText() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final String recognizedText = await recognizeText(image.path);
      setState(() {
        _recognizedText = recognizedText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  Column(
      children: [
        ElevatedButton(
          onPressed: _pickImageAndRecognizeText,
          child: const Text('Pick Image and Recognize Text'),
        ),
        const SizedBox(height: 20),
        const Text('Recognized Text:'),
        SingleChildScrollView(child: Text(_recognizedText)),
      ],
    ),
    );
  }
Future<String> recognizeText(String imagePath) async {
  final inputImage = InputImage.fromFilePath(imagePath);
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  
  try {
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    
    String text = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          // You can access more granular info about the recognized text here
          // print(element.text);
          text = "$text${element.text} ";
        }
      }
    }
    if (text.contains("Europe")) {
      text = "Europe";
    }else if(text.contains("United States Of America")){
      text = "USA";
    }
    
    return text;
  } catch (e) {
    print('Error recognizing text: $e');
    return '';
  } finally {
    textRecognizer.close();
  }
}
// Future<bool> recognizeImage(String imagePath){
//   final inputImage = InputImage.fromFilePath(imagePath);
//   final imageFinder = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.92));
// }
}
