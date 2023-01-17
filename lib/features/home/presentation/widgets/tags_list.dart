import 'package:flutter/material.dart';
import 'package:slow/features/home/domain/tag_model.dart';
import 'package:slow/themes/text_style.dart';

class TagsList extends StatelessWidget {
  final List<TagModel> tags;
  const TagsList({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return tags.isNotEmpty
        ? SizedBox(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (TagModel tagCurrent in tags)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(
                          tagCurrent.hexColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Center(
                          child: Text(
                            tagCurrent.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.w400S18H22White,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : const SizedBox();
  }
}
