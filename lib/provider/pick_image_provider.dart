import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class PickImageProvider extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> _imageFileList;
  String retrieveDataError;

  dynamic pickImageError;

  PickImageProvider({this.retrieveDataError = ''}) : _imageFileList = [];

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? [] : [value];
  }

  XFile? get lastImage {
    if (_imageFileList.isEmpty) return null;
    return _imageFileList.last;
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);
      _imageFile = pickedFile;
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
      _imageFile = response.file;
    } else {
      retrieveDataError = response.exception!.code;
    }
    notifyListeners();
  }
}
