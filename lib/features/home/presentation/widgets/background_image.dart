import 'package:flutter/material.dart';
import 'package:slow/resources/resources.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        Images.bgPattern,
        fit: BoxFit.cover,
      ),
    );
  }
}
