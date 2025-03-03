import 'package:flutter/material.dart';
import 'package:geozebra_app/models/theme_model.dart';
import '../models/info_lesson_model.dart';
import '../widgets/defaultappbar_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:io';

class InfoLessonScreen extends StatefulWidget {
  final InfoLesson lesson;

  const InfoLessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<InfoLessonScreen> createState() => _InfoLessonScreenState();
}

class _InfoLessonScreenState extends State<InfoLessonScreen> {
  final Map<String, dynamic> _videoControllers = {};
  bool _isNetworkConnected = true;

  @override
  void initState() {
    super.initState();
    _checkNetworkConnection();
    _initializeVideoPlayers();
  }

  Future<void> _checkNetworkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        _isNetworkConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      });
    } on SocketException catch (_) {
      setState(() {
        _isNetworkConnected = false;
      });
    }
  }

  void _initializeVideoPlayers() {
    for (var i = 0; i < widget.lesson.sections.length; i++) {
      final section = widget.lesson.sections[i];
      if (section.type == ContentType.video) {
        try {
          // Ensure URL is using HTTPS for Android emulator
          String videoUrl = section.content;
          if (videoUrl.startsWith('http:') && !videoUrl.startsWith('https:')) {
            videoUrl = videoUrl.replaceFirst('http:', 'https:');
            debugPrint('Converting video URL to HTTPS: $videoUrl');
          }
          
          // Ensure URL is properly encoded
          final uri = Uri.parse(videoUrl);
          
          debugPrint('Loading video from: $uri');
          final videoController = VideoPlayerController.networkUrl(uri);
          
          _videoControllers['video_$i'] = {
            'controller': videoController,
            'future': videoController.initialize().then((_) {
              // Auto-pause when initialized to avoid playing multiple videos
              videoController.pause();
              if (mounted) {
                setState(() {});
              }
              debugPrint('Video initialized successfully: ${section.content}');
            }).catchError((error) {
              debugPrint('Video initialization error (${section.content}): $error');
              if (mounted) {
                setState(() {
                  _videoControllers['video_$i']['error'] = 'Cannot play video: ${error.toString()}';
                });
              }
            }),
            'error': null,
            'url': videoUrl,
          };
        } catch (e) {
          debugPrint('Error creating video controller (${section.content}): $e');
          _videoControllers['video_$i'] = {
            'error': 'Failed to load video: ${e.toString()}',
            'url': section.content,
          };
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers.values) {
      if (controller.containsKey('controller')) {
        controller['controller'].dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: widget.lesson.title),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ...widget.lesson.sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            return _buildSectionCard(section, index);
          }),
        ],
      ),
    );
  }

  Widget _buildSectionCard(ContentSection section, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.0,
      child: ExpansionTile(
        title: Text(
          section.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        initiallyExpanded: section.isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            section.isExpanded = expanded;
            // Pause all videos when closing sections
            if (!expanded && section.type == ContentType.video) {
              final videoKey = 'video_$index';
              if (_videoControllers.containsKey(videoKey) && 
                  _videoControllers[videoKey].containsKey('controller')) {
                _videoControllers[videoKey]['controller'].pause();
              }
            }
          });
        },
        backgroundColor: Theme.of(context).extension<TaskColors>()?.uncompletedTask,
        collapsedBackgroundColor: Theme.of(context).extension<TaskColors>()?.uncompletedTask,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildContentWidget(section, index),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWidget(ContentSection section, int index) {
    // If there's no network connection, show a message
    if (!_isNetworkConnected) {
      return Column(
        children: [
          const Icon(Icons.signal_wifi_off, size: 50, color: Colors.grey),
          const SizedBox(height: 10),
          const Text(
            'No internet connection',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Connection'),
            onPressed: () async {
              await _checkNetworkConnection();
              setState(() {});
            },
          ),
        ],
      );
    }

    switch (section.type) {
      case ContentType.text:
        return Text(
          section.content,
          style: const TextStyle(fontSize: 16.0),
        );
        
      case ContentType.video:
        final videoKey = 'video_$index';
        
        // If there's an error, show error message with fallback
        if (_videoControllers.containsKey(videoKey) && 
            _videoControllers[videoKey].containsKey('error') && 
            _videoControllers[videoKey]['error'] != null) {
          return Column(
            children: [
              const Icon(Icons.videocam_off, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              Text(
                _videoControllers[videoKey]['error'],
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Show the URL for debugging
              _videoControllers[videoKey].containsKey('url') ? 
              SelectableText(
                'URL: ${_videoControllers[videoKey]['url']}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ) : const SizedBox(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    onPressed: () {
                      setState(() {
                        if (_videoControllers[videoKey].containsKey('controller')) {
                          _videoControllers[videoKey]['controller'].dispose();
                        }
                        _videoControllers.remove(videoKey);
                        
                        // Try with an alternative URL format
                        String videoUrl = section.content;
                        if (videoUrl.startsWith('http:') && !videoUrl.startsWith('https:')) {
                          videoUrl = videoUrl.replaceFirst('http:', 'https:');
                        }
                        
                        final videoController = VideoPlayerController.networkUrl(
                          Uri.parse(videoUrl),
                        );
                        
                        _videoControllers[videoKey] = {
                          'controller': videoController,
                          'future': videoController.initialize().then((_) {
                            videoController.pause();
                            if (mounted) {
                              setState(() {});
                            }
                          }).catchError((error) {
                            if (mounted) {
                              setState(() {
                                _videoControllers[videoKey]['error'] = 'Cannot play video: ${error.toString()}';
                              });
                            }
                          }),
                          'error': null,
                          'url': videoUrl,
                        };
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  // Add an external link option
                  ElevatedButton(
                    child: const Text('Show Preview'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Video Preview'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Video cannot be played directly due to emulator limitations.'),
                              const SizedBox(height: 10),
                              Image.asset(
                                'assets/video_placeholder.png', // You'll need to add this placeholder image
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.videocam,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        }
        
        // If the video is not in our controllers map yet, show loading
        if (!_videoControllers.containsKey(videoKey)) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        // Use FutureBuilder for handling initialization state
        return FutureBuilder(
          future: _videoControllers[videoKey]['future'],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && 
                !_videoControllers[videoKey].containsKey('error')) {
              // Video is ready to play
              final controller = _videoControllers[videoKey]['controller'];
              // Check if the controller actually has a valid video
              if (controller.value.isInitialized) {
                return Column(
                  children: [
                    AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                // Pause all other videos before playing this one
                                for (var key in _videoControllers.keys) {
                                  if (key != videoKey && 
                                      _videoControllers[key].containsKey('controller')) {
                                    _videoControllers[key]['controller'].pause();
                                  }
                                }
                                controller.play();
                              }
                            });
                          },
                        ),
                        // Show current position and total duration
                        ValueListenableBuilder(
                          valueListenable: controller,
                          builder: (context, VideoPlayerValue value, child) {
                            return Text(
                              '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                              style: const TextStyle(fontSize: 14),
                            );
                          },
                        ),
                        // Add a mute/unmute button
                        IconButton(
                          icon: Icon(
                            controller.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
                          ),
                          onPressed: () {
                            setState(() {
                              if (controller.value.volume > 0) {
                                controller.setVolume(0);
                              } else {
                                controller.setVolume(1.0);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    // Simple video position slider
                    ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, VideoPlayerValue value, child) {
                        return Slider(
                          value: value.position.inMilliseconds.toDouble(),
                          max: value.duration.inMilliseconds.toDouble(),
                          onChanged: (newPosition) {
                            controller.seekTo(Duration(milliseconds: newPosition.round()));
                          },
                        );
                      },
                    ),
                  ],
                );
              } else {
                // Controller is initialized but video is not available
                setState(() {
                  _videoControllers[videoKey]['error'] = 'Video format not supported on this device';
                });
                return const Center(child: Text('Video format not supported on this device'));
              }
            } else if (snapshot.hasError) {
              // Error occurred during initialization
              return Column(
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text('Error loading video: ${snapshot.error}'),
                ],
              );
            } else {
              // If the video is still loading, show a progress indicator
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading video...'),
                  ],
                ),
              );
            }
          },
        );
      
      case ContentType.image:
        return Column(
          children: [
            Image.network(
              section.content,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Image error: $error');
                return Column(
                  children: [
                    const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text('Failed to load image'),
                    const SizedBox(height: 5),
                    Text(
                      'URL: ${section.content}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => setState(() {}),  // Force refresh
                      child: const Text('Retry'),
                    ),
                  ],
                );
              },
            ),
            // Add a small note about the image URL for debugging
            Text(
              'Source: ${Uri.parse(section.content).host}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        );
    }
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
