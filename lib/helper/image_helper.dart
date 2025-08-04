/*
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ImageHelper {
  Future<String?> pickImage(BuildContext context) async {
    _requestStoragePermissions();
    final ImagePicker picker = ImagePicker();
    // GetxNavigation.goBack();
    final XFile? result = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      requestFullMetadata: true,
    );
    // GetxNavigation().goBack();
    if (result != null) {
      String? filePath = await _cropImage(result, context);
      return filePath;
    } else {
      // User canceled the picker
      return null;
    }
  }

  Future<List<String?>> pickMultipleImage(
      BuildContext context, int maxImages) async {
    await _requestStoragePermissions();
    final ImagePicker picker = ImagePicker();

    final List<XFile> result = await picker.pickMultiImage(
      imageQuality: 100,
      requestFullMetadata: true,
    );

    List<String?> images = [];

    if (result.isNotEmpty) {
      // Limit to maxImages manually
      final List<XFile> limitedResult = result.take(maxImages).toList();

      for (var element in limitedResult) {
        String? filePath = await _cropImage(element, context);
        images.add(filePath);
      }
      return images;
    } else {
      return [];
    }
  }

  Future<String?> captureImage(BuildContext context) async {
    _requestStoragePermissions();
    final ImagePicker picker = ImagePicker();
    // GetxNavigation.goBack();
    final XFile? result = await picker.pickImage(source: ImageSource.camera);

    if (result != null) {
      String? filePath = await _cropImage(result, context);
      return filePath;
    } else {
      // User canceled the picker
      return null;
    }
  }

  Future<void> _requestStoragePermissions() async {
    final storagePermissionStatus = await Permission.storage.status;
    final cameraPermissionStatus = await Permission.camera.status;
    if (!storagePermissionStatus.isGranted) {
      await Permission.storage.request(); // Request read permission
    }
    if (!cameraPermissionStatus.isGranted) {
      await Permission.camera.request(); // Request read permission
    }
  }

  Future<String?> _cropImage(XFile? pickedFile, BuildContext context) async {
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image Pragnesh',
            toolbarColor: Colors.red,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            backgroundColor: Colors.white,
            activeControlsWidgetColor: Colors.green,
            statusBarColor: Colors.yellow,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatio2x2(),
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatio2x2(),
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(width: 520, height: 520),
          ),
        ],
      );
      if (croppedFile != null) {
        return croppedFile.path;
      }
      return pickedFile.path;
    }
    return null;
  }

  static Future<String> imageToBase64(String path) async {
    if (path.isEmpty) {
      print("❌ Error: Empty image path provided");
      return "";
    }

    try {
      File imageFile = File(path);

      if (!await imageFile.exists()) {
        throw Exception("❌ Error: Image file does not exist");
      }

      final mimeType = lookupMimeType(path);
      if (mimeType == null) {
        throw Exception("❌ Unsupported image type");
      }

      Uint8List imageBytes;
      int originalSize = await imageFile.length();

      if (originalSize > 495 * 1024) {
        print("🔧 Compressing image to <500KB...");
        imageBytes =
            await _compressToUnder500KB(path) ?? await imageFile.readAsBytes();
      } else {
        imageBytes = await imageFile.readAsBytes();
      }

      String base64String = base64.encode(imageBytes);
      print("✅ Image successfully converted to base64");

      return "data:$mimeType;base64,$base64String";
    } catch (e) {
      print("❌ Error converting image to base64: $e");
      return "";
    }
  }

  static Future<Uint8List?> _compressToUnder500KB(String path) async {
    const int targetSize = 500 * 1024;
    int quality = 90;

    Uint8List? compressedBytes;

    while (quality >= 10) {
      compressedBytes = await FlutterImageCompress.compressWithFile(
        path,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) return null;

      print(
          "📦 Tried quality $quality → ${compressedBytes.lengthInBytes ~/ 1024} KB");

      if (compressedBytes.lengthInBytes <= targetSize) {
        return compressedBytes;
      }

      quality -= 10;
    }

    return compressedBytes; // return best we got, even if > 500KB
  }

  // Uint8List to base64
  static String uint8ListToBase64(Uint8List data) {
    final mimeType = lookupMimeType('', headerBytes: data) ?? 'application/octet-stream';
    final base64String = base64.encode(data);
    return 'data:$mimeType;base64,$base64String';
  }
}

class CropAspectRatio2x2 implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (1, 1);

  @override
  String get name => '1x1';
}*/
