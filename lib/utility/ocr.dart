import 'dart:io';

import "package:google_ml_kit/google_ml_kit.dart";
import 'package:image_picker/image_picker.dart';

class OCR {
  static Future<String?> startOcr() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return null;
    final imagePath = img.path;
    return ocr(File(imagePath));
  }

  static Future<String?> ocr(File? imageFile) async {
    if (imageFile != null) {
      final inputImage = InputImage.fromFile(imageFile);
      final textDetector = GoogleMlKit.vision.textDetector();
      final visionText = await textDetector.processImage(inputImage);
      await textDetector.close();
      return extractIDandName(visionText);
    }
  }

  static String? extractIDandName(RecognisedText recognisedText) {
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        RegExp idRegex = RegExp(r"20[12]\d.*\d{4}H");
        // if (line.text.contains("ID")) {
        if (idRegex.hasMatch(line.text)) {
          final mat = idRegex.firstMatch(line.text);
          return mat?.group(0);
        }
      }
    }
  }
}

class OcrResult {
  OcrResult({this.name, this.id});
  String? name, id;
}
