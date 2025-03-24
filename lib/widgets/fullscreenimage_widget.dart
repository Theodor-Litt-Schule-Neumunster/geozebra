import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullscreenImageViewer extends StatelessWidget {
  final String imagePath;
  final bool isNetworkImage;

  const FullscreenImageViewer({
    Key? key,
    required this.imagePath,
    this.isNetworkImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          minScale: 0.5,
          maxScale: 4.0,
          child: isNetworkImage 
              ? CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  cacheHeight: 2048, // Higher resolution caching
                  cacheWidth: 2048,  // Adjust based on your needs
                ),
        ),
      ),
    );
  }
}
