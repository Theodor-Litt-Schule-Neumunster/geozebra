import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'fullscreenvideo_widget.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Convert GitHub URL to a raw URL if needed.
    final url = _getRawUrl(widget.videoUrl);
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    });
  }

  String _getRawUrl(String url) {
    if (url.contains("github.com") && url.contains("blob")) {
      return url
          .replaceFirst("github.com", "raw.githubusercontent.com")
          .replaceFirst("/blob", "");
    }
    return url;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
Widget build(BuildContext context) {
  if (!_controller.value.isInitialized) {
    return const Center(child: CircularProgressIndicator());
  }
  return AspectRatio(
    aspectRatio: _controller.value.aspectRatio,
    child: Stack(
      alignment: Alignment.center,
      children: [
        VideoPlayer(_controller),
        // Existing play/pause button.
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause_circle : Icons.play_circle,
            size: 64,
            color: Colors.white,
          ),
          onPressed: _togglePlay,
        ),
        // Fullscreen button (positioned in the top right)
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: const Icon(
              Icons.fullscreen,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigate to the fullscreen widget
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FullscreenVideoPlayer(
                  controller: _controller,
                ),
              ));
            },
          ),
        ),
      ],
    ),
  );
}
}
