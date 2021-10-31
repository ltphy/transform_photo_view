import 'package:flutter/cupertino.dart';

class AnimationControllerProvider extends ChangeNotifier {
  bool isSaved = false;
  bool isDone = false;

  AnimationControllerProvider({this.isSaved = false, this.isDone = false});

  final TransformationController transformationController =
      TransformationController();

  void updateControllerReset(AnimationController controller) {
    Matrix4 homeMatrix = Matrix4.identity();
    transformationController.value = homeMatrix;
  }

  updateSave() {
    isSaved = !isSaved;
    notifyListeners();
  }

  updateDone() {
    isDone = !isDone;
    notifyListeners();
  }

  Offset transformOffset(Offset point) {
    Offset result = transformationController.toScene(point);
    return result;
  }

}
