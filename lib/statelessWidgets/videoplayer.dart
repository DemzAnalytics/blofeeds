import 'package:blofeeds/store/actions/index.dart';
import 'package:blofeeds/store/index.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPLayer extends StatefulWidget {
  VideoPLayer({Key key, this.keypoint, this.userId, this.catId, this.numShown});
  final String userId;
  final int catId;
  final int numShown;
  final List keypoint;
  @override
  _VideoPLayerState createState() => _VideoPLayerState();
}

class _VideoPLayerState extends State<VideoPLayer> {
  VideoPlayerController _controller;
  int index;
  bool init = false;

  @override
  void initState() {
    super.initState();
    index = 0;
    _controller = VideoPlayerController.network(widget.keypoint[0])
    ..initialize().then((_) {
        setState(() {
          init = true;
        });
      });
    _controller.play();
    
  }

  void _addToUserPreference(String userId, int catId, int numShown){
    if(_controller.value.duration != null && _controller.value.duration >= Duration(seconds: 3)){
        Redux.store.dispatch(setUserPreferenece(Redux.store, userId, catId, numShown));
    }
  }

    _swapItems(){
    int newIndex = index + 1;
    int lenKeypoints = widget.keypoint.length;
    setState(() {
      init = false;
    });
    if(newIndex == lenKeypoints){
      setState(() {
        init = true;
      });
    }else{
      index = newIndex;
      _controller = VideoPlayerController.network(widget.keypoint[newIndex])        
        ..initialize().then((_) {
          setState(() {
            init = true;
          });
        _controller.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: init?
              GestureDetector(
                child:  AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                onTap: (){if(widget.keypoint != null){
                  _swapItems();
                }},
              ):
              Container(
                alignment: Alignment.center,
                height: 50,
                child: CircularProgressIndicator(),
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