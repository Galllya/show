import 'package:flutter/material.dart';
import 'package:slow/features/home/domain/tag_model.dart';
import 'package:slow/themes/text_style.dart';

class TagCustom extends StatelessWidget {
  final TagModel tag;
  const TagCustom({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(
            tag.hexColor,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Center(
            child: Text(
              tag.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.w400S18H22White,
            ),
          ),
        ),
      ),
    );
  }
}
