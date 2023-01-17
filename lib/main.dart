import 'package:flutter/material.dart';
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:slow/features/home/presentation/pages/home_page.dart';
import 'package:slow/themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: applicationTheme,
      builder: ((context, child) {
        return PersistentKeyboardHeightProvider(
          child: child!,
        );
      }),
      home: const HomePage(),
    );
  }
}
