import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view_picker/provider/animation_controller_provider.dart';
import 'package:photo_view_picker/provider/pick_image_provider.dart';
import 'package:photo_view_picker/screens/background_image_screen/widgets/map_canvas.dart';
import 'package:provider/provider.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({Key? key}) : super(key: key);

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  final GlobalKey _targetKey = GlobalKey();

  final GlobalKey _imageTargetKey = GlobalKey();
  late PhotoViewScaleStateController scaleStateController;
  late PhotoViewController controller;
  Offset setOffset = Offset.zero;
  Offset setOffset2 = Offset.zero;

  late PickImage pickImage;

  // double scale = (1 / 0.4789 * 0.58111);
  double scale = 1;

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    controller = PhotoViewController()..outputStateStream.listen(listener);
  }

  void listener(PhotoViewControllerValue value) {
    Offset imagePoint = value.position;

    // setOffset = offset;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scaleStateController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PickImageProvider>(
      builder: (BuildContext context, pickImageProvider, __) {
        final _pickImageError = pickImageProvider.pickImageError;
        final _retrieveDataError = pickImageProvider.retrieveDataError;
        final PickImage? image = pickImageProvider.lastImage;
        if (_retrieveDataError.isNotEmpty) {
          return Text(_retrieveDataError);
        }
        if (image != null) {
          pickImage = image;
          print(context.watch<AnimationControllerProvider>().different /
              pickImage.width);
          return Stack(
            children: [
              Container(
                color: Colors.black,
                child: ClipRect(
                  child: InteractiveViewer(
                    key: _targetKey,
                    transformationController: context
                        .read<AnimationControllerProvider>()
                        .transformationController,
                    scaleEnabled:
                        !context.watch<AnimationControllerProvider>().isSaved ||
                            context.watch<AnimationControllerProvider>().isDone,
                    panEnabled:
                        !context.watch<AnimationControllerProvider>().isSaved ||
                            context.watch<AnimationControllerProvider>().isDone,
                    minScale: 0.1,
                    maxScale: 5,
                    boundaryMargin: const EdgeInsets.all(5000),
                    child: Stack(
                      children: [
                        if (context.watch<AnimationControllerProvider>().isDone)
                          PhotoView(
                            key: UniqueKey(),
                            imageProvider: FileImage(File(image.path)),
                            basePosition: Alignment.topLeft,
                            initialScale: context
                                .watch<AnimationControllerProvider>()
                                .scale,
                            controller: controller
                              ..position = context
                                  .read<AnimationControllerProvider>()
                                  .topLeft,
                          ),
                        Opacity(
                          opacity: 0.5,
                          child: RepaintBoundary(
                            child: CustomPaint(
                              child: Container(),
                              painter: MapCanvas(
                                topLeft: context
                                    .watch<AnimationControllerProvider>()
                                    .topLeft,
                                bottomRight: context
                                    .watch<AnimationControllerProvider>()
                                    .topRight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!context.watch<AnimationControllerProvider>().isDone)
                if (image.path.isNotEmpty &&
                    context.watch<AnimationControllerProvider>().isSaved)
                  Opacity(
                    opacity: 0.8,
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
                      child: ClipRect(
                        child: InteractiveViewer(
                          key: _imageTargetKey,
                          transformationController: context
                              .watch<AnimationControllerProvider>()
                              .imageTransformationController,
                          boundaryMargin: const EdgeInsets.all(5000),
                          constrained: false,
                          minScale: 0.1,
                          maxScale: 5,
                          child: Image.file(
                            File(image.path),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          );
        } else if (_pickImageError != null) {
          return Text(
            'Pick image error: $_pickImageError',
            textAlign: TextAlign.center,
          );
        } else {
          return Center(
            child: const Text(
              'You have not yet picked an image.',
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }
}
