import 'dart:io';
import 'dart:math';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:slow/features/home/domain/message_model.dart';
import 'package:slow/features/home/domain/tag_model.dart';
import 'package:slow/features/home/presentation/bloc/bloc/home_bloc.dart';
import 'package:slow/features/home/presentation/widgets/tags_list.dart';
import 'package:slow/resources/resources.dart';
import 'package:slow/themes/colors.dart';
import 'package:slow/themes/text_style.dart';
import 'package:path/path.dart' as p;

class HomeView extends StatefulWidget {
  final Function(MessageModel message) addMessageEvent;
  const HomeView({
    required this.addMessageEvent,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isEmojiVisible = false;
  bool isKeyboardVisible = false;
  bool writingTeg = false;
  bool haveTextInMessage = false;
  bool isEmojiVisibleNow = false;

  List<Color> colorsList = const [
    Color(0xFF4CAF50),
    Color(0xFFF44336),
    Color(0xFF2196F3),
    Color(0xFFE91E63),
    Color(0xFFFFEB3B),
    Color(0xFFFF9800),
    Color(0xFF009688),
  ];

  List<TagModel> tags = [];

  FocusNode focusNode = FocusNode();

  List<String> filePaths = [];

  TextEditingController textEditingController = TextEditingController();

  void addMessage(String message) {
    if (writingTeg) {
      closeTag();
    }
    MessageModel messageModel = MessageModel(
      title: message,
      tags: tags,
      filePaths: filePaths,
    );
    widget.addMessageEvent(messageModel);
    setState(() {
      tags = [];
      filePaths = [];
    });
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

  int numbersOffAddedCharacters = 0;

  @override
  void initState() {
    textEditingController.addListener(
      () {
        if (writingTeg) {
          createTag();
        } else {
          numbersOffAddedCharacters = textEditingController.text.length;
        }
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

  void createTag() {
    if (textEditingController.text.isNotEmpty) {
      int len = 0;
      if (textEditingController.text.length - numbersOffAddedCharacters > 3) {
        len = textEditingController.text.length - numbersOffAddedCharacters - 3;
      }
      final unitsCode = textEditingController.text[len].codeUnits;

      if ((unitsCode.first == 10 || unitsCode.first == 32) && len != 0) {
        closeTag();
      }
    }
  }

  void closeTag() {
    writingTeg = false;

    tags.add(
      TagModel(
        title:
            '# ${textEditingController.text.substring(0, textEditingController.text.length - numbersOffAddedCharacters - 3)}',
        hexColor: colorsList[Random().nextInt(
          colorsList.length,
        )]
            .value,
      ),
    );
    textEditingController.text = textEditingController.text.substring(
        textEditingController.text
            .substring(0,
                textEditingController.text.length - numbersOffAddedCharacters)
            .length);

    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: textEditingController.text.length,
      ),
    );
    numbersOffAddedCharacters = 0;
  }

  Future<void> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<String> paths = [];

      for (var element in result.paths) {
        paths.add(
          element!,
        );
      }
      filePaths.addAll(paths);
    } else {}
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
            return WillPopScope(
              onWillPop: (() {
                if (isEmojiVisible || isKeyboardVisible) {
                  Navigator.canPop(context);
                  return Future.value(false);
                } else {
                  return Future.value(false);
                }
              }),
              child: KeyboardVisibility(
                onChanged: (visible) {
                  setState(() {
                    isKeyboardVisible = visible;
                  });
                },
                child: Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Image.asset(
                        Images.bgPattern,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ListView(
                            reverse: true,
                            padding: const EdgeInsets.all(0),
                            children: [
                              for (MessageModel message in messages.reversed)
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 60,
                                        right: 10,
                                        bottom: 10,
                                      ),
                                      child: Stack(
                                        alignment:
                                            AlignmentDirectional.bottomStart,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 5,
                                                    horizontal: 10,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TagsList(
                                                          tags: message.tags),
                                                      if (message
                                                          .filePaths.isNotEmpty)
                                                        Row(
                                                          children: [
                                                            for (String path
                                                                in message
                                                                    .filePaths)
                                                              if (p.extension(
                                                                        path,
                                                                      ) ==
                                                                      '.jpg' ||
                                                                  p.extension(
                                                                        path,
                                                                      ) ==
                                                                      '.png' ||
                                                                  p.extension(
                                                                        path,
                                                                      ) ==
                                                                      '.jpeg')
                                                                ConstrainedBox(
                                                                  constraints:
                                                                      const BoxConstraints(
                                                                    maxHeight:
                                                                        200,
                                                                    maxWidth:
                                                                        100,
                                                                  ),
                                                                  child: Image
                                                                      .file(
                                                                    File(path),
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    scale: 5,
                                                                  ),
                                                                ),
                                                          ],
                                                        ),
                                                      Text(
                                                        message.title,
                                                        style: AppTextStyles
                                                            .w400S18H22White,
                                                      ),
                                                    ],
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
                        if (tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            child: TagsList(
                              tags: tags,
                            ),
                          ),
                        ColoredBox(
                          color: AppColors.primary,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              10,
                              5,
                              10,
                              isEmojiVisible || isKeyboardVisible ? 0 : 40,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        pickFile();
                                      },
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
                                            style:
                                                AppTextStyles.w400S16H20White,
                                            maxLines: 5,
                                            minLines: 1,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
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
                                          Positioned(
                                            left: 0,
                                            bottom: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 5, 4, 10),
                                              child: InkWell(
                                                onTap: () {
                                                  if (!writingTeg) {
                                                    setState(() {
                                                      writingTeg = !writingTeg;
                                                      focusNode.requestFocus();
                                                      isEmojiVisible = false;
                                                      isEmojiVisibleNow = false;
                                                    });
                                                    textEditingController.text =
                                                        "  ${textEditingController.text}";
                                                    textEditingController
                                                            .selection =
                                                        TextSelection
                                                            .fromPosition(
                                                      const TextPosition(
                                                        offset: 0,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    color: writingTeg
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
                                            child: isEmojiVisible &&
                                                    !isKeyboardVisible
                                                ? IconButton(
                                                    onPressed: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              focusNode);
                                                      setState(() {
                                                        isKeyboardVisible =
                                                            true;
                                                      });
                                                      setState(() {
                                                        isEmojiVisible =
                                                            !isEmojiVisible;
                                                        Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500), () {
                                                          setState(() {
                                                            isEmojiVisibleNow =
                                                                isEmojiVisible;
                                                          });
                                                        });
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.keyboard,
                                                      size: 21,
                                                      color: AppColors.items,
                                                    ),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      setState(() {
                                                        isKeyboardVisible =
                                                            false;
                                                      });
                                                      setState(() {
                                                        isEmojiVisible =
                                                            !isEmojiVisible;
                                                      });
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  500), () {
                                                        setState(() {
                                                          isEmojiVisibleNow =
                                                              isEmojiVisible;
                                                        });
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
                                    haveTextInMessage || filePaths.isNotEmpty
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
                          offstage: !(isEmojiVisible && isEmojiVisibleNow),
                          child: SizedBox(
                            height: PersistentKeyboardHeight.of(context)
                                .keyboardHeight,
                            child: isEmojiVisible
                                ? EmojiPicker(
                                    onEmojiSelected:
                                        (Category? category, Emoji emoji) {
                                      _onEmojiSelected(emoji);
                                    },
                                    onBackspacePressed: _onBackspacePressed,
                                    config: Config(
                                      columns: 7,
                                      emojiSizeMax:
                                          32 * (Platform.isIOS ? 1.30 : 1.0),
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
                                      tabIndicatorAnimDuration:
                                          kTabScrollDuration,
                                      categoryIcons: const CategoryIcons(),
                                      buttonMode: ButtonMode.MATERIAL,
                                    ),
                                  )
                                : const ColoredBox(
                                    color: AppColors.primary,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
