import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:woxsen/Values/subjects_list.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

class VideoPlayerScreen extends StatefulWidget {
  final String? url;
  final String? filename;
  final String? userId;

  const VideoPlayerScreen({
    Key? key,
    required this.url,
    required this.filename,
    required this.userId,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isLoading = true;
  String? _videoUrl;
  ListStore store = ListStore();

  @override
  void initState() {
    super.initState();
    _fetchVideoUrl();
  }

  Future<void> _fetchVideoUrl() async {
    try {
      final response = await http.post(
        Uri.parse('${store.woxUrl}/api/st_leave_get_doc'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'doc_is': 'video_url',
          'user_id': '${widget.userId}',
        }),
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final tempVideoPath = '${tempDir.path}/${widget.filename}';

        debugPrint('Temp Video Path: $tempVideoPath');

        final file = File(tempVideoPath);
        await file.writeAsBytes(bytes);

        debugPrint('TEMP VIDEO PATH: $tempVideoPath');
        debugPrint('DEFAULT TARGET PLATFORM: $defaultTargetPlatform');
        debugPrint('DEFAULT TARGET  FILE: $file');

        // setState(() {
        //   _videoUrl = tempVideoPath;
        //   _controller =
        //       VideoPlayerController.networkUrl(Uri.parse('_videoUrl!'));
        //   _initializeVideoPlayerFuture = _controller.initialize();
        //   _isLoading = false;
        // });

        setState(() {
          _videoUrl = tempVideoPath;

          if (!kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.windows ||
                  defaultTargetPlatform == TargetPlatform.linux ||
                  defaultTargetPlatform == TargetPlatform.macOS)) {
            // Use File controller for desktop
            _controller = VideoPlayerController.file(file);
          } else {
            // Use Network controller for mobile/web
            _controller =
                VideoPlayerController.networkUrl(Uri.parse(_videoUrl!));
          }

          _initializeVideoPlayerFuture = _controller.initialize().then((_) {
            setState(() {
              _isLoading = false;
            });
            _controller.play();
          }).catchError((error) {
            setState(() {
              _isLoading = false;
            });
            print('Error initializing video player: $error');
          });
        });
      } else {
        throw Exception('Failed to load video URL');
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Widget Video URL: $_videoUrl');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back navigation
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Supporting Video'),
      ),
      body: _isLoading || _videoUrl == null
          ? const Center(child: CircularProgressIndicator())
          : _videoUrl == null || _videoUrl!.isEmpty
              ? const Center(child: Text('Error loading video'))
              : FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoPlayer(_controller),
                              _PlayPauseOverlay(controller: _controller),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
