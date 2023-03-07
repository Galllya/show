import 'package:flutter/material.dart';
import 'package:slow/themes/colors.dart';
import 'package:slow/themes/text_style.dart';

class AddFilesStrip extends StatelessWidget {
  final int filesLen;
  const AddFilesStrip({
    super.key,
    required this.filesLen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            'you add $filesLen files',
            style: AppTextStyles.w400S16H20White,
          ),
        ),
      ),
    );
  }
}
