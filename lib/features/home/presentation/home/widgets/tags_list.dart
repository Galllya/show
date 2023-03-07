import 'package:flutter/material.dart';
import 'package:slow/features/home/domain/tag_model.dart';
import 'package:slow/features/home/presentation/home/widgets/tag_custom.dart';

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
                  TagCustom(
                    tag: tagCurrent,
                  )
              ],
            ),
          )
        : const SizedBox();
  }
}
