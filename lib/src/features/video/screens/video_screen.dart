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
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool tayormi = false;

  @override
  void initState() {
    super.initState();
    print('URl linke ${widget.url}');
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url))
          ..initialize().then((v) {
            _chewieController =
                ChewieController(videoPlayerController: _videoPlayerController);
            tayormi = true;
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoTitle),
      ),
      body: Platform.isIOS ? Center(child: Text('IOS DA video yoq'),) : tayormi == true
          ? Chewie(controller: _chewieController)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
