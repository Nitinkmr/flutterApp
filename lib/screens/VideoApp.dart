import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatelessWidget {
  // @override
  // _VideoAppState createState() => _VideoAppState();
  String url;
  VideoApp({Key? key, required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: _VideoAppState(url:this.url),
    );
  }
}

class _VideoAppState extends StatefulWidget {

  String url;
  _VideoAppState({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(url:this.url);
}

class _VideoPlayerScreenState extends State<_VideoAppState>{
  String url;
  _VideoPlayerScreenState({Key? key, required this.url}) ;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  int duration = 200;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      url,
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
    startVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Butterfly Video'),
        ),
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  Future<void>startVideo() {
    return Future.delayed(Duration(seconds: 2), () => _controller.play());
  }
}

