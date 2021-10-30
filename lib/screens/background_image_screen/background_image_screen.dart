import 'package:flutter/material.dart';

import 'widgets/body.dart';

class BackgroundImageScreen extends StatelessWidget {
  const BackgroundImageScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  Future<void> uploadImage() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Image'),
      ),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => uploadImage(),
        child: const Icon(Icons.upload),
      ),
    );
  }
}
