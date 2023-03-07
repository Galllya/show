import 'package:flutter/material.dart';
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:slow/features/home/domain/tag_model.dart';
import 'package:slow/features/home/presentation/home/widgets/tag_custom.dart';
import 'package:slow/themes/colors.dart';
import 'package:slow/themes/text_style.dart';

class ListDropDown extends StatelessWidget {
  final bool isKeyboardVisible;
  final bool isEmojiVisible;
  final List<TagModel> tagsInSelect;
  final Function(TagModel tag) onTagSelect;
  const ListDropDown({
    required this.isEmojiVisible,
    required this.isKeyboardVisible,
    required this.tagsInSelect,
    required this.onTagSelect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isKeyboardVisible
              ? 0
              : isEmojiVisible
                  ? PersistentKeyboardHeight.of(context).keyboardHeight
                  : 40,
          left: 60,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              15,
            ),
            color: AppColors.lightGrey,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var tag in tagsInSelect)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                onTagSelect(tag);
                              },
                              child: TagCustom(
                                tag: tag,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      '#',
                      style: AppTextStyles.w400S18H22White,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
