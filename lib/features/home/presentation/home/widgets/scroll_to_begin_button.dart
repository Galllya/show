import 'package:flutter/material.dart';
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:slow/themes/colors.dart';

class ScrollToBeginButton extends StatelessWidget {
  final bool isKeyboardVisible;
  final bool isEmojiVisible;
  final VoidCallback scrollToBegin;
  const ScrollToBeginButton({
    super.key,
    required this.isEmojiVisible,
    required this.isKeyboardVisible,
    required this.scrollToBegin,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isKeyboardVisible
              ? 80
              : isEmojiVisible
                  ? PersistentKeyboardHeight.of(context).keyboardHeight + 80
                  : 100,
          right: 10,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: scrollToBegin,
          child: const CircleAvatar(
            backgroundColor: AppColors.primaryDark,
            radius: 20,
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
