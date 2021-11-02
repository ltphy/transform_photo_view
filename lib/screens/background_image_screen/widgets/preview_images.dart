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
  late PhotoViewScaleStateController scaleStateController;
  late PhotoViewController controller;
  Offset setOffset = Offset.zero;
  Offset setOffset2 = Offset.zero;

  // double scale = (1 / 0.4789 * 0.58111);
  double scale = 1;
  final TransformationController imageTransformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    controller = PhotoViewController()..outputStateStream.listen(listener);
  }

  void listener(PhotoViewControllerValue value) {
    print(value);
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

  void updateController(ScaleUpdateDetails details) {
    // print('update $details');
    print(
        ' scale: ${context.read<AnimationControllerProvider>().transformationController.value.getMaxScaleOnAxis()}');
    print(
        'transform: ${context.read<AnimationControllerProvider>().transformationController.value}');
  }

  void updateImageController(ScaleUpdateDetails details) {
    print('update controller image ${imageTransformationController.value}');
    print('details $details');
    final imagePoint = imageTransformationController.value.getTranslation();
    final maxScale = imageTransformationController.value.getMaxScaleOnAxis();
    Offset offset = context
        .read<AnimationControllerProvider>()
        .transformOffset(Offset(imagePoint[0], imagePoint[1]));
    print('media width: ${MediaQuery.of(context).size.width}');
    print('width ${WidgetsBinding.instance?.window.physicalSize.height}');
    Offset topRight = Offset(400 * maxScale, 0);
    Offset topRightConverted = topRight.translate(imagePoint[0], imagePoint[1]);
    print('topRightCOnverted: $topRightConverted');
    Offset offset2 = context
        .read<AnimationControllerProvider>()
        .transformOffset(topRightConverted);
    print('offset $offset');

    print('offset ${offset2}');
    setOffset = offset;
    setOffset2 = offset2;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PickImageProvider>(
      builder: (BuildContext context, pickImageProvider, __) {
        final _pickImageError = pickImageProvider.pickImageError;
        final _retrieveDataError = pickImageProvider.retrieveDataError;
        final image = pickImageProvider.lastImage;
        if (_retrieveDataError.isNotEmpty) {
          return Text(_retrieveDataError);
        }
        if (image != null) {
          return Stack(
            children: [
              Container(
                color: Colors.black,
                child: ClipRect(
                  child: InteractiveViewer(
                    key: _targetKey,
                    onInteractionUpdate: updateController,
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
                            scaleStateController: scaleStateController,
                            enablePanAlways: true,
                            initialScale: scale,
                            controller: controller
                              // ..scale = scale
                              ..position = setOffset,
                          ),
                        Opacity(
                          opacity: 0.5,
                          child: RepaintBoundary(
                            child: CustomPaint(
                              child: Container(),
                              painter: MapCanvas(
                                topLeft: setOffset,
                                bottomRight: setOffset2,
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
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: ClipRect(
                        child: InteractiveViewer(
                          transformationController:
                              imageTransformationController,
                          boundaryMargin: const EdgeInsets.all(10000),
                          onInteractionUpdate: updateImageController,
                          minScale: 0.1,
                          maxScale: 5,
                          child: Image.file(File(image.path)),
                        ),
                      ),
                    ),
                  )
              // Opacity(
              //   opacity: 0.5,
              //   child: ClipRect(
              //     child: PhotoView(
              //       key: ValueKey(image.path),
              //       imageProvider: FileImage(File(image.path)),
              //       scaleStateController: scaleStateController,
              //       enablePanAlways: true,
              //       controller: controller
              //         // ..position = Offset(876.2, 816.5)
              //         ..scale = 1,
              //     ),
              //   ),
              // ),
            ],
          );
          // return Container(
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   child: Stack(
          //     children: [
          //       // ClipRect(
          //       //   child: InteractiveViewer(
          //       //     key: ValueKey(image.path),
          //       //     minScale: 0.1,
          //       //     maxScale: 5,
          //       //     boundaryMargin: const EdgeInsets.all(1000),
          //       //     scaleEnabled: true,
          //       //     child: Image.file(
          //       //       File(image.path),
          //       //     ),
          //       //   ),
          //       // ),
          //       InteractiveViewer(
          //         key: _targetKey,
          //         minScale: 0.1,
          //         maxScale: 5,
          //         boundaryMargin: const EdgeInsets.all(1000),
          //         scaleEnabled: true,
          //         child: CustomPaint(
          //           painter: MapCanvas(
          //             topLeft: Offset(-225.3, 228.6),
          //             bottomRight: Offset(876.2, 816.5),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // );
          // return InteractiveViewer(
          //   panEnabled: true,
          //   boundaryMargin: EdgeInsets.only(
          //     left: 1000,
          //     top: 1000,
          //     right: 1000,
          //     bottom: 1000,
          //   ),
          //   minScale: 1,
          //   maxScale: 10,
          //   child: Stack(children: [
          //     ClipRect(
          //       child: PhotoView(
          //         key: ValueKey(image.path),
          //         imageProvider: FileImage(File(image.path)),
          //         scaleStateController: scaleStateController,
          //         enablePanAlways: false,
          //         controller: controller,
          //       ),
          //     )
          //   ]),
          // );
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
