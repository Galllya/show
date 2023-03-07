import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:slow/themes/colors.dart';

class EmojiPickerCustom extends StatelessWidget {
  final bool isEmojiVisible;
  final Function(Emoji emoji) onEmojiSelected;
  final VoidCallback onBackspacePressed;
  const EmojiPickerCustom({
    super.key,
    required this.isEmojiVisible,
    required this.onBackspacePressed,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !(isEmojiVisible),
      child: SizedBox(
        height: PersistentKeyboardHeight.of(context).keyboardHeight,
        child: isEmojiVisible
            ? EmojiPicker(
                onEmojiSelected: (Category? category, Emoji emoji) {
                  onEmojiSelected(emoji);
                },
                onBackspacePressed: onBackspacePressed,
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  initCategory: Category.RECENT,
                  bgColor: AppColors.primary,
                  indicatorColor: Colors.white,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.white,
                  backspaceColor: Colors.white,
                  showRecentsTab: true,
                  recentsLimit: 28,
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                ),
              )
            : const ColoredBox(
                color: AppColors.primary,
              ),
      ),
    );
  }
}
