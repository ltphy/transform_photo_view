import 'package:flutter/cupertino.dart';
import 'package:photo_view_picker/provider/pick_image_provider.dart';

class AnimationControllerProvider extends ChangeNotifier {
  bool isSaved = false;
  bool isDone = false;
  final PickImageProvider pickImageProvider;
  final TransformationController imageTransformationController =
      TransformationController();
  Offset topLeft = Offset.zero;
  Offset topRight = Offset.zero;

  AnimationControllerProvider({
    this.isSaved = false,
    this.isDone = false,
    required this.pickImageProvider,
  });

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
    final PickImage? pickImage = pickImageProvider.lastImage;
    if (pickImage == null) return;
    isDone = !isDone;

    final imagePoint = imageTransformationController.value.getTranslation();
    final offsetImagePoint = Offset(imagePoint[0], imagePoint[1]);
    Offset offset = transformOffset(offsetImagePoint);

    final scaleRatio = imageTransformationController.value.getMaxScaleOnAxis();

    Offset topRightConverted =
        offsetImagePoint.translate(pickImage.width.toDouble() * scaleRatio, 0);

    Offset offset2 = transformOffset(topRightConverted);
    topLeft = offset;
    topRight = offset2;
    notifyListeners();
  }

  Offset transformOffset(Offset point) {
    Offset result = transformationController.toScene(point);
    return result;
  }

  double get different => topRight.dx - topLeft.dx;

  double get scale {
    final PickImage? pickImage = pickImageProvider.lastImage;
    if (pickImage == null) return 1;
    return different / pickImage.width;
  }
}
