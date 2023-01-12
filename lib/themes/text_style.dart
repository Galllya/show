import 'package:flutter/material.dart';

abstract class AppTextStyles {
  static TextStyle w400S16H20WhiteWithOpacity = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 20 / 16,
    color: Colors.white.withOpacity(0.5),
  );
  static TextStyle w400S18H22White = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    height: 22 / 18,
    color: Colors.white,
  );
}
