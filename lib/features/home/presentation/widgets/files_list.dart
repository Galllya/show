import 'dart:io';

import 'package:flutter/material.dart';
import 'package:slow/features/home/domain/message_model.dart';
import 'package:path/path.dart' as p;
import 'package:slow/features/home/presentation/widgets/audio_player_custom.dart';
import 'package:slow/features/home/presentation/widgets/gallery_custom.dart';
import 'package:slow/features/home/presentation/widgets/video_player_custom.dart';

class FilesList extends StatelessWidget {
  final MessageModel message;
  const FilesList({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return (message.filePaths.isNotEmpty)
        ? GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: message.filePaths.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: ((context, index) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 100,
                ),
                child: (p.extension(
                              message.filePaths[index],
                            ) ==
                            '.jpg' ||
                        p.extension(
                              message.filePaths[index],
                            ) ==
                            '.png' ||
                        p.extension(
                              message.filePaths[index],
                            ) ==
                            '.jpeg' ||
                        p.extension(
                              message.filePaths[index],
                            ) ==
                            '.gif')
                    ? InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          List<String> imagesList = message.filePaths
                              .where((element) => (p.extension(
                                        element,
                                      ) ==
                                      '.jpg' ||
                                  p.extension(
                                        element,
                                      ) ==
                                      '.png' ||
                                  p.extension(
                                        element,
                                      ) ==
                                      '.jpeg' ||
                                  p.extension(
                                        element,
                                      ) ==
                                      '.gif'))
                              .toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => GalleryCustom(
                                    initialImage: imagesList.lastIndexOf(
                                      message.filePaths[index],
                                    ),
                                    galleryItems: imagesList,
                                  )),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(
                              message.filePaths[index],
                            ),
                            fit: BoxFit.cover,
                            scale: 5,
                          ),
                        ),
                      )
                    : p.extension(
                              message.filePaths[index],
                            ) ==
                            '.mp4'
                        ? InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => VideoPlayerCustom(
                                        videoUrl: message.filePaths[index],
                                      )),
                                ),
                              );
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: const Icon(
                                Icons.video_camera_front,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : p.extension(
                                      message.filePaths[index],
                                    ) ==
                                    '.mp3' ||
                                p.extension(
                                      message.filePaths[index],
                                    ) ==
                                    '.m4a'
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) =>
                                            AudioPlayerCustom(
                                              audioPath:
                                                  message.filePaths[index],
                                            )),
                                      ));
                                },
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.audiotrack,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const SizedBox(),
              );
            }),
          )
        : const SizedBox();
  }
}
