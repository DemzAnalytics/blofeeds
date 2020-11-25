import 'dart:async';
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
  Duration videoDuration;

  @override
  void initState() {
    super.initState();
    index = 0;
    startIt();
    
  }

  void setTimer(){
    Duration duration = videoDuration * 0.66;
    Timer(duration, _addToUserPreference);
  }

  _addToUserPreference(){
    Redux.store.dispatch(setUserPreferenece(Redux.store, widget.userId, widget.catId, widget.numShown));
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
        index = 0;
      });
    }else {
      setState(()  {
        index = newIndex;
      });
      startIt2(widget.keypoint[newIndex]);
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

  void startIt() async{
    _controller = VideoPlayerController.network('http://10.0.2.2:9000/v1/static/w401t8fo3vyytmaepxcj/w401t8fo3vyytmaepxcj.mpd', formatHint: VideoFormat.dash);
      await _controller.initialize().then((_) {
        setState(() {
          init = true;
          videoDuration = _controller.value.duration;
        });
        if(index ==0){setTimer();}
      });
    _controller.play();
  }

void startIt2(keypoint) async {
  _controller = VideoPlayerController.network(keypoint);
    await _controller.initialize().then((_) {
      setState(() {
        init = true;
      });
      _controller.play();
    });
  }
}