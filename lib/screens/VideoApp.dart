import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_samples/models/User.dart';
import 'package:flutterfire_samples/services/database_service.dart';
import 'package:flutterfire_samples/widgets/message_tile.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatelessWidget {
  // @override
  // _VideoAppState createState() => _VideoAppState();
  // currentUser refers to the user whose video is being played
  User currentUser;
  String loggedInUserEmail;
  VideoApp({Key? key, required this.currentUser, required this.loggedInUserEmail}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: _VideoAppState(currentUser:this.currentUser,loggedInUserEmail:this.loggedInUserEmail),
    );
  }
}

class _VideoAppState extends StatefulWidget {

  User currentUser;
  String loggedInUserEmail;
  _VideoAppState({Key? key, required this.currentUser, required this.loggedInUserEmail}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(currentUser:currentUser,loggedInUserEmail:this.loggedInUserEmail);
}

class _VideoPlayerScreenState extends State<_VideoAppState>{
  User currentUser;
  String loggedInUserEmail;
  late Stream<QuerySnapshot> _chats;
  _VideoPlayerScreenState({Key? key, required this.currentUser, required this.loggedInUserEmail}) ;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  int duration = 200;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      currentUser.liveUrls[0],
    );

  _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
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
        body: Container(
          child: Stack(
            children: <Widget>[
              setupVideo(),
             // _chatMessages(),
            ],
          ),
        )




    );
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  Future<void>startVideo() async{

    //check if group exists
    QuerySnapshot groupExists = await DatabaseService().searchByName(currentUser.id);

    if(groupExists.docs.isNotEmpty){
      DatabaseService().getChats(currentUser.id).then((val) {
        // print(val);
        setState(() {
          _chats = val;
        });
      });
    }else{
      DatabaseService().createGroup(currentUser.name, currentUser.name, loggedInUserEmail);
    }

    return Future.delayed(Duration(seconds: 2), () => _controller.play());
  }

  Widget setupVideo() {
    return FutureBuilder(
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
        );
  }

  Widget _chatMessages(){
    return StreamBuilder(
      stream: _chats,
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data!.docs[index]["message"],
                sender: snapshot.data!.docs[index]["sender"],
                //sentByMe: widget.userName == snapshot.data.documents[index].data["sender"],
              );
            }
        )
            :
        Container();
      },
    );
  }
}

