import 'package:flutter/material.dart';

import 'widgets/body.dart';

class PreviewBackgroundImage extends StatelessWidget {
  const PreviewBackgroundImage({Key? key}) : super(key: key);
  static const String routeName = '/preview_background_image';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backgrond Image'),
      ),
      body: Body(),
    );
  }
}
