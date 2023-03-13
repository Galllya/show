import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:slow/features/home/domain/message_model.dart';
import 'package:slow/features/home/domain/tag_model.dart';
import 'package:slow/features/home/presentation/widgets/message_container.dart';
import 'package:slow/features/home/presentation/widgets/tag_custom.dart';
import 'package:slow/features/home/presentation/search/bloc/search_bloc.dart';
import 'package:slow/themes/colors.dart';
import 'package:slow/themes/text_style.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool isKeyboardVisible = false;
  bool isMessageShow = false;
  late TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    textEditingController.addListener(
      () {
        if (textEditingController.text.isEmpty) {
          setState(() {
            isMessageShow = false;
          });
        } else {
          setState(() {
            isMessageShow = true;
          });
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox(),
          load: (tags, message) {
            return KeyboardVisibility(
              onChanged: (visible) {
                setState(() {
                  isKeyboardVisible = visible;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: isMessageShow
                          ? [
                              for (MessageModel message in message)
                                MessageContainer(
                                  message: message,
                                ),
                            ]
                          : [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    8,
                                  ),
                                  child: Wrap(
                                    children: [
                                      for (TagModel tag in tags)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8,
                                            bottom: 8,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                isMessageShow = true;
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TagCustom(
                                                  tag: tag,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              )
                            ],
                    ),
                    ColoredBox(
                      color: AppColors.primary,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: isKeyboardVisible ? 0 : 40,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  TextField(
                                    controller: textEditingController,
                                    keyboardAppearance: Brightness.dark,
                                    style: AppTextStyles.w400S16H20White,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                        right: 40,
                                        left: 12,
                                        top: 12,
                                        bottom: 12,
                                      ),
                                      labelText: 'Search',
                                      labelStyle: AppTextStyles
                                          .w400S16H20WhiteWithOpacity,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      filled: true,
                                      fillColor: AppColors.primaryDark,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide.none,
                                      ),
                                      isDense: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
