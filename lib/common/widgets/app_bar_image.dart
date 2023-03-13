import 'package:flutter/material.dart';
import 'package:slow/resources/resources.dart';

class AppBarImage extends StatelessWidget {
  const AppBarImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage(
        Images.logo,
      ),
    );
  }
}
