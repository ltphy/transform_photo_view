import 'package:flutter/material.dart';
import 'package:photo_view_picker/screens/background_image_screen/background_image_screen.dart';
import 'package:photo_view_picker/screens/preview_background_image/preview_background_image.dart';
import 'package:provider/provider.dart';

import 'provider/pick_image_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PickImageProvider>(
            create: (context) => PickImageProvider()),
      ],
      child: MaterialApp(
        title: 'Background Image Uploader',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case BackgroundImageScreen.routeName:
              return MaterialPageRoute(
                builder: (context) {
                  return BackgroundImageScreen();
                },
                settings: settings,
              );
            case PreviewBackgroundImage.routeName:
              return MaterialPageRoute(
                builder: (context) {
                  return PreviewBackgroundImage();
                },
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
