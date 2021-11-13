import 'package:flutter/material.dart';
import 'package:photo_view_picker/provider/animation_controller_provider.dart';
import 'package:photo_view_picker/provider/pick_image_provider.dart';

import 'widgets/body.dart';
import 'package:provider/provider.dart';

class BackgroundImageScreen extends StatelessWidget {
  const BackgroundImageScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  Future<void> uploadImage(BuildContext context) async {
    await context.read<PickImageProvider>().pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return AnimationControllerProvider(
              pickImageProvider:
                  Provider.of<PickImageProvider>(context, listen: false),
            );
          },
        )
      ],
      child: Scaffold(
        appBar: PreferredSize(
            child: Builder(
              builder: (BuildContext context) {
                return AppBar(
                  title: Text('Background Image'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        context
                            .read<AnimationControllerProvider>()
                            .updateSave();
                      },
                      icon: Icon(Icons.save),
                    ),
                    IconButton(
                      onPressed: () {
                        context
                            .read<AnimationControllerProvider>()
                            .updateDone();
                      },
                      icon: Icon(Icons.check),
                    ),
                  ],
                );
              },
            ),
            preferredSize: const Size(double.infinity, kToolbarHeight)),
        body: Body(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => uploadImage(context),
          child: const Icon(Icons.upload),
        ),
      ),
    );
  }
}
