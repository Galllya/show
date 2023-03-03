import 'dart:io';
import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persistent_keyboard_height/flutter_persistent_keyboard_height.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:slow/features/home/domain/message_model.dart';
import 'package:slow/features/home/domain/tag_model.dart';
import 'package:slow/features/home/presentation/bloc/bloc/home_bloc.dart';
import 'package:slow/features/home/presentation/widgets/add_files_strip.dart';
import 'package:slow/features/home/presentation/widgets/background_image.dart';
import 'package:slow/features/home/presentation/widgets/bottom_row/bottom_row.dart';
import 'package:slow/features/home/presentation/widgets/emoji_picker_custom.dart';
import 'package:slow/features/home/presentation/widgets/files_list.dart';
import 'package:slow/features/home/presentation/widgets/bottom_row/list_drop_down.dart';
import 'package:slow/features/home/presentation/widgets/message_container.dart';
import 'package:slow/features/home/presentation/widgets/scroll_to_begin_button.dart';
import 'package:slow/features/home/presentation/widgets/tag_custom.dart';
import 'package:slow/features/home/presentation/widgets/tags_list.dart';
import 'package:slow/resources/resources.dart';
import 'package:slow/themes/colors.dart';
import 'package:slow/themes/text_style.dart';

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
  bool isTagWritting = false;
  bool haveTextInMessage = false;
  bool showListDropDown = false;
  ScrollController scrollController = ScrollController();

  List<Color> colorsList = const [
    Color(0xFF4CAF50),
    Color(0xFFF44336),
    Color(0xFF2196F3),
    Color(0xFFE91E63),
    Color(0xFFFFEB3B),
    Color(0xFFFF9800),
    Color(0xFF009688),
  ];

  List<TagModel> tagsInSelect = [
    TagModel(
      title: '# kontrasocial',
      hexColor: const Color(0xff2400FF).value,
    ),
    TagModel(
      title: '# beplalogi',
      hexColor: const Color(0xffFF0000).value,
    ),
    TagModel(
      title: '# ipsum',
      hexColor: const Color(0xff00C2FF).value,
    ),
    TagModel(
      title: '# lorem',
      hexColor: const Color(0xff00FF38).value,
    ),
  ];

  List<TagModel> tags = [];

  FocusNode focusNode = FocusNode();

  List<String> filePaths = [];

  TextEditingController textEditingController = TextEditingController();

  void addMessage(String message) {
    if (isTagWritting) {
      closeTag();
    }
    if (textEditingController.text.isNotEmpty || filePaths.isNotEmpty) {
      MessageModel messageModel = MessageModel(
        title: textEditingController.text,
        tags: tags,
        filePaths: filePaths,
      );
      widget.addMessageEvent(messageModel);
    }
    setState(() {
      tags = [];
      filePaths = [];
    });
    textEditingController.text = '';
    scrollToBegin();
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
  bool showScrollToBeginButton = false;
  @override
  void initState() {
    textEditingController.addListener(
      () {
        if (isTagWritting) {
          createTag();
        } else {
          numbersOffAddedCharacters = textEditingController.text.length;
        }
        setState(() {
          if (textEditingController.text.isNotEmpty) {
            haveTextInMessage = true;
          } else {
            haveTextInMessage = false;
          }
        });
      },
    );
    scrollController.addListener(
      () {
        setState(() {
          if (scrollController.offset > 200) {
            showScrollToBeginButton = true;
          } else {
            showScrollToBeginButton = false;
          }
        });
      },
    );
    super.initState();
  }

  void createTag() {
    if (textEditingController.text.isNotEmpty) {
      int len = 0;
      int textLength = textEditingController.text.length;
      if (textLength - numbersOffAddedCharacters > 3) {
        len = textLength - numbersOffAddedCharacters - 3;
      }
      final unitsCode = textEditingController.text[len].codeUnits;
      int lastCharacterUniCode = unitsCode.first;
      if ((lastCharacterUniCode == 10 || lastCharacterUniCode == 32) &&
          len != 0) {
        closeTag();
      }
    }
  }

  void closeTag() {
    isTagWritting = false;
    int endTagPosition =
        textEditingController.text.length - numbersOffAddedCharacters;
    tags.add(
      TagModel(
        title:
            '# ${textEditingController.text.substring(0, endTagPosition - 3)}',
        hexColor: colorsList[Random().nextInt(
          colorsList.length,
        )]
            .value,
      ),
    );
    textEditingController.text = textEditingController.text.substring(
      textEditingController.text.substring(0, endTagPosition).length,
    );

    textEditingController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: textEditingController.text.length,
      ),
    );
    numbersOffAddedCharacters = 0;
  }

  void addTagFromDropDown(TagModel selectTag) {
    tags.add(
      selectTag,
    );
    setState(() {
      showListDropDown = false;
    });
  }

  pickFile() async {
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
      setState(() {});
    } else {}
  }

  scrollToBegin() {
    scrollController.animateTo(
      0,
      duration: const Duration(microseconds: 500),
      curve: Curves.ease,
    );
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
                    const BackgroundImage(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ListView(
                            reverse: true,
                            padding: const EdgeInsets.all(0),
                            controller: scrollController,
                            children: [
                              for (MessageModel message in messages.reversed)
                                MessageContainer(
                                  message: message,
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
                        if (filePaths.isNotEmpty)
                          AddFilesStrip(
                            filesLen: filePaths.length,
                          ),
                        BottomRow(
                          pickFile: pickFile,
                          focusNode: focusNode,
                          textEditingController: textEditingController,
                          onLongTagPress: () => setState(() {
                            showListDropDown = true;
                          }),
                          onTagTap: () {
                            if (!isTagWritting) {
                              setState(() {
                                isTagWritting = !isTagWritting;
                                focusNode.requestFocus();
                                isEmojiVisible = false;
                              });
                              textEditingController.text =
                                  "  ${textEditingController.text}";
                              textEditingController.selection =
                                  TextSelection.fromPosition(
                                const TextPosition(
                                  offset: 0,
                                ),
                              );
                            }
                          },
                          isTagWritting: isTagWritting,
                          isEmojiVisible: isEmojiVisible,
                          isKeyboardVisible: isKeyboardVisible,
                          onKeyboardTap: () {
                            FocusScope.of(context).requestFocus(focusNode);
                            setState(() {
                              isKeyboardVisible = true;
                              isEmojiVisible = false;
                            });
                          },
                          onEmojiTap: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isKeyboardVisible = false;
                            });
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              setState(() {
                                isEmojiVisible = true;
                              });
                            });
                          },
                          showSend: haveTextInMessage || filePaths.isNotEmpty,
                          onSendTap: () => addMessage(
                            textEditingController.text,
                          ),
                        ),
                        EmojiPickerCustom(
                          isEmojiVisible: isEmojiVisible,
                          onBackspacePressed: _onBackspacePressed,
                          onEmojiSelected: _onEmojiSelected,
                        )
                      ],
                    ),
                    if (showScrollToBeginButton)
                      ScrollToBeginButton(
                        scrollToBegin: () {
                          scrollToBegin();
                        },
                        isEmojiVisible: isEmojiVisible,
                        isKeyboardVisible: isKeyboardVisible,
                      ),
                    if (showListDropDown)
                      ListDropDown(
                        isEmojiVisible: isEmojiVisible,
                        isKeyboardVisible: isKeyboardVisible,
                        tagsInSelect: tagsInSelect,
                        onTagSelect: (TagModel tag) {
                          addTagFromDropDown(tag);
                        },
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
