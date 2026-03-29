import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vlad_ai/app/config/app_colors.dart';

class PhotoViewScreen extends StatefulWidget {
  const PhotoViewScreen({super.key, required this.photos});

  final List<String> photos;

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        iconTheme: IconThemeData(color: AppColors.white),
        actions: [
          Text(
            '${selectedIndex + 1}/${widget.photos.length}',
            style: const TextStyle(fontSize: 16, color: AppColors.white),
          ),
          SizedBox(width: 20),
        ],
      ),
      backgroundColor: AppColors.black,
      body: SizedBox.expand(
        child: PageView.builder(
          itemCount: widget.photos.length,
          onPageChanged: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: CachedNetworkImage(
                imageUrl: widget.photos[index],
                placeholder: (context, url) => const CircularProgressIndicator(),
                imageBuilder: (context, imageProvider) => InteractiveViewer(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        // fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
