import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:slow/features/home/presentation/bloc/bloc/home_bloc.dart';
import 'package:slow/resources/resources.dart';
import 'package:slow/themes/colors.dart';
import 'package:slow/themes/text_style.dart';

class HomeView extends StatefulWidget {
  final Function(String message) addMessageEvent;
  const HomeView({
    required this.addMessageEvent,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool emojiShowing = false;
  bool writingTeg = false;
  bool haveTextInMessage = false;

  TextEditingController textEditingController = TextEditingController();

  void addMessage(String message) {
    widget.addMessageEvent(message);
    textEditingController.text = '';
  }

  _onEmojiSelected(Emoji emoji) {
    textEditingController.text += emoji.emoji;
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: textEditingController.text.length,
      ),
    );
  }

  _onBackspacePressed() {
    textEditingController.text =
        textEditingController.text.characters.skipLast(1).toString();
    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: textEditingController.text.length,
      ),
    );
  }

  @override
  void initState() {
    textEditingController.addListener(
      () {
        if (textEditingController.text.isNotEmpty) {
          setState(() {
            haveTextInMessage = true;
          });
        } else {
          setState(() {
            haveTextInMessage = false;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: ((context, state) {
        return state.maybeWhen(
          orElse: () {
            return const SizedBox();
          },
          loaded: (messages) {
            return Stack(
              children: [
                SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset(Images.bgPattern, fit: BoxFit.fill)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        padding: const EdgeInsets.all(0),
                        children: [
                          for (String message in messages.reversed)
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 60,
                                    right: 10,
                                    bottom: 10,
                                  ),
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.baseGrey,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                15,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 10,
                                              ),
                                              child: Text(
                                                message,
                                                style: AppTextStyles
                                                    .w400S18H22White,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Image.asset(
                                          Images.dialogPart,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    ColoredBox(
                      color: AppColors.primary,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          10,
                          5,
                          10,
                          emojiShowing ? 0 : 40,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
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
                                        controller: textEditingController,
                                        style: AppTextStyles
                                            .w400S16H20WhiteWithOpacity,
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
                                          labelStyle: AppTextStyles
                                              .w400S16H20WhiteWithOpacity,
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          filled: true,
                                          fillColor: AppColors.primaryDark,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide.none,
                                          ),
                                          isDense: true,
                                        ),
                                      ),
                                      if (!writingTeg)
                                        Positioned(
                                          left: 0,
                                          bottom: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 5, 4, 10),
                                            child: InkWell(
                                              onTap: () {
                                                print('popopo');
                                                setState(() {
                                                  writingTeg = !writingTeg;
                                                });
                                                textEditingController.text =
                                                    "# ${textEditingController.text} ";
                                              },
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: AppColors.baseGrey,
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
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              emojiShowing = !emojiShowing;
                                            });
                                          },
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
                                haveTextInMessage
                                    ? IconButton(
                                        onPressed: () {
                                          addMessage(
                                            textEditingController.text,
                                          );
                                        },
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
                          ],
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !emojiShowing,
                      child: SizedBox(
                        height: 250,
                        child: EmojiPicker(
                          onEmojiSelected: (Category? category, Emoji emoji) {
                            _onEmojiSelected(emoji);
                          },
                          onBackspacePressed: _onBackspacePressed,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
