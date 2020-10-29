import 'package:blofeeds/store/actions/index.dart';
import 'package:blofeeds/store/index.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPLayer extends StatefulWidget {
  VideoPLayer({Key key, this.url, this.userId, this.catId, this.numShown});
  final String url;
  final String userId;
  final int catId;
  final int numShown;
  @override
  _VideoPLayerState createState() => _VideoPLayerState();
}

class _VideoPLayerState extends State<VideoPLayer> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://www.youtube.com/watch?v=xSSa9LFneSEr')
    ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
    _controller.addListener(() {_addToUserPreference(widget.userId, widget.catId, widget.numShown); });
    
  }

  void _addToUserPreference(String userId, int catId, int numShown){
    if(_controller.value.duration != null && _controller.value.duration >= Duration(seconds: 3)){
        Redux.store.dispatch(setUserPreferenece(Redux.store, userId, catId, numShown));
    }
  }

  @override
  Widget build(BuildContext context) {
    print('-------------duration-----------');
    print(_controller.value.duration);
    return Scaffold(
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(
                alignment: Alignment.center,
                height: 50,
                child: CircularProgressIndicator(),
              ),
          ),
          
        ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}