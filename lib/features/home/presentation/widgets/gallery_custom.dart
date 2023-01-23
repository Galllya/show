import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryCustom extends StatefulWidget {
  final List<String> galleryItems;
  final int initialImage;
  const GalleryCustom({
    super.key,
    required this.galleryItems,
    required this.initialImage,
  });

  @override
  State<GalleryCustom> createState() => _GalleryCustomState();
}

class _GalleryCustomState extends State<GalleryCustom> {
  late PageController pageController;

  changePage(int page) {
    pageController.jumpToPage(page);
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: widget.initialImage,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Expanded(
              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: FileImage(
                      File(widget.galleryItems[index]),
                    ),
                    initialScale: PhotoViewComputedScale.contained * 0.8,
                  );
                },
                itemCount: widget.galleryItems.length,
                loadingBuilder: (context, event) => Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                    ),
                  ),
                ),
                backgroundDecoration: const BoxDecoration(),
                pageController: pageController,
                onPageChanged: changePage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
