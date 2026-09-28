import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key, required this.url, required this.videoTitle});

  final String url;
  final String videoTitle;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  bool get _isReady => _chewieController != null;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    _videoPlayerController.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
        );
      });
    });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.videoTitle)),
      body: Platform.isIOS
          ? Center(child: Text('IOS DA video yoq'))
          : _isReady
          ? Chewie(controller: _chewieController!)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
