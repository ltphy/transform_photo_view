import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

class PickImage {
  final String path;
  final int width;
  final int height;

  PickImage({required this.path, required this.width, required this.height});
}

class PickImageProvider extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  List<PickImage> _imageFileList;
  String retrieveDataError;

  dynamic pickImageError;

  PickImageProvider({this.retrieveDataError = ''}) : _imageFileList = [];

  set _imageFile(PickImage? value) {
    _imageFileList = value == null ? [] : [value];
  }

  PickImage? get lastImage {
    if (_imageFileList.isEmpty) return null;
    return _imageFileList.last;
  }

  Future<PickImage> getSelectFile(PickedFile pickedFile) async {
    File image =
        File(pickedFile.path); // Or any other way to get a File instance.

    ui.Image decodedImage = await decodeImageFromList(image.readAsBytesSync());
    return PickImage(
        path: pickedFile.path,
        width: decodedImage.width,
        height: decodedImage.height);
  }

  Future<PickImage> getPickImage(String path) async {
    File image = File(path); // Or any other way to get a File instance.
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    print(decodedImage.width);
    print(decodedImage.height);
    return PickImage(
      path: path,
      width: decodedImage.width,
      height: decodedImage.height,
    );
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);
      String? path = pickedFile?.path;
      if (path != null) {
        _imageFile = await getPickImage(path);
      }
    } catch (error) {
      pickImageError = error;
    }
    notifyListeners();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _imageFile = await getPickImage(response.file!.path);
    } else {
      retrieveDataError = response.exception!.code;
    }
    notifyListeners();
  }
}
