import 'dart:io';

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

  @override
  void initState() {
    super.initState();
    scaleStateController = PhotoViewScaleStateController();
    controller = PhotoViewController()..outputStateStream.listen(listener);
  }

  void listener(PhotoViewControllerValue value) {
    print(value);
    Offset imagePoint = value.position;
    Offset offset =
        context.read<AnimationControllerProvider>().transformOffset(imagePoint);
    print('offset $offset');
    setOffset = offset;
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
              ClipRect(
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
                          initialScale: 1.0,
                          // controller: controller
                          //   ..scale = 1
                          //   ..position = Offset.zero,
                        ),
                      Opacity(
                        opacity: 0.5,
                        child: RepaintBoundary(
                          child: CustomPaint(
                            child: Container(),
                            painter: MapCanvas(
                              topLeft: Offset(-225.3, 228.6),
                              bottomRight: Offset(876.2, 816.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!context.watch<AnimationControllerProvider>().isDone)
                if (image.path.isNotEmpty &&
                    context.watch<AnimationControllerProvider>().isSaved)
                  Opacity(
                    opacity: 0.5,
                    child: ClipRect(
                      child: PhotoView(
                        key: ValueKey(image.path),
                        imageProvider: FileImage(File(image.path)),
                        scaleStateController: scaleStateController,
                        enablePanAlways: true,
                        controller: controller
                          // ..position = Offset(876.2, 816.5)
                          ..scale = 1,
                      ),
                    ),
                  ),
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
