import 'package:flutter/material.dart';
import 'package:slow/features/home/domain/message_model.dart';
import 'package:slow/features/home/presentation/home/widgets/files_list.dart';
import 'package:slow/features/home/presentation/home/widgets/tags_list.dart';
import 'package:slow/resources/resources.dart';
import 'package:slow/themes/colors.dart';
import 'package:slow/themes/text_style.dart';

class MessageContainer extends StatelessWidget {
  final MessageModel message;
  const MessageContainer({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                padding: const EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.baseGrey,
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TagsList(tags: message.tags),
                          const SizedBox(
                            height: 4,
                          ),
                          FilesList(message: message),
                          Text(
                            message.title,
                            style: AppTextStyles.w400S18H22White,
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
    );
  }
}
