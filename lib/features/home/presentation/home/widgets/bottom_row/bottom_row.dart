import 'package:flutter/material.dart';
import 'package:slow/themes/colors.dart';
import 'package:slow/themes/text_style.dart';

class BottomRow extends StatelessWidget {
  final VoidCallback pickFile;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final VoidCallback onLongTagPress;
  final VoidCallback onTagTap;
  final bool isTagWritting;
  final bool isEmojiVisible;
  final bool isKeyboardVisible;
  final VoidCallback onKeyboardTap;
  final VoidCallback onEmojiTap;
  final bool showSend;
  final VoidCallback onSendTap;
  const BottomRow({
    required this.pickFile,
    required this.focusNode,
    required this.textEditingController,
    required this.onLongTagPress,
    required this.onTagTap,
    required this.isTagWritting,
    required this.isKeyboardVisible,
    required this.isEmojiVisible,
    required this.onKeyboardTap,
    required this.onEmojiTap,
    required this.showSend,
    required this.onSendTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          10,
          5,
          10,
          isEmojiVisible || isKeyboardVisible ? 0 : 40,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: pickFile,
              icon: const Icon(
                Icons.add,
                color: AppColors.items,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    keyboardAppearance: Brightness.dark,
                    focusNode: focusNode,
                    controller: textEditingController,
                    style: AppTextStyles.w400S16H20White,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        right: 40,
                        left: 40,
                        top: 12,
                        bottom: 12,
                      ),
                      labelText: 'Message',
                      labelStyle: AppTextStyles.w400S16H20WhiteWithOpacity,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      filled: true,
                      fillColor: AppColors.primaryDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 4, 10),
                      child: InkWell(
                        onLongPress: onLongTagPress,
                        onTap: onTagTap,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: isTagWritting
                                ? AppColors.primaryDark
                                : AppColors.baseGrey,
                          ),
                          child: const Icon(
                            Icons.tag,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: isEmojiVisible && !isKeyboardVisible
                        ? IconButton(
                            onPressed: onKeyboardTap,
                            icon: const Icon(
                              Icons.keyboard,
                              size: 21,
                              color: AppColors.items,
                            ),
                          )
                        : IconButton(
                            onPressed: onEmojiTap,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              size: 21,
                              color: AppColors.items,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            showSend
                ? IconButton(
                    onPressed: onSendTap,
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.items,
                    ),
                  )
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic,
                      color: AppColors.items,
                      size: 25,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
