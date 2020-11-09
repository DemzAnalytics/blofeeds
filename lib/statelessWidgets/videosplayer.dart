import 'dart:async';
import 'package:blofeeds/store/actions/index.dart';
import 'package:blofeeds/store/index.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideosPlayer extends StatefulWidget {
  VideosPlayer({Key key, this.keypoint, this.userId, this.catId, this.numShown});
  final String userId;
  final int catId;
  final int numShown;
  final List keypoint;
  @override
  _VideosPlayerState createState() => _VideosPlayerState();
}

class _VideosPlayerState extends State<VideosPlayer> {
  List<VideoPlayerController> _controllerList;
  int index;
  bool init = false;
  Duration videoDuration;
  bool error = false;

  @override
  void initState(){
    super.initState();
    index = 0;
    _initializeVideos();    
  }

  _initializeVideos(){
    print('======initializing video=======');
    _controllerList = [];
    for(var video in widget.keypoint){
      var videoUrl = video.split('/').last;
      var actualURl = videoUrl.split('.')[0];
      var finalUrl = url+'/video-to-dash' +'/'+actualURl+'/'+actualURl+'.mpd';
      print(finalUrl);
      VideoPlayerController _controller;
      _controller = VideoPlayerController.network(video)
      ..initialize().then((_) {
        print('========initialized video========');
        if(index == 0){
          _controller.setLooping(true);
          setState(() {
            init = true;
            videoDuration = _controller.value.duration;
          });
          setTimer();
        }else{
          setState(() {
            init = true;
          });
        }
      _controllerList.add(_controller);
      });
    }
  }

  void setTimer(){
    Duration duration = videoDuration * 0.66;
    Timer(duration, _addToUserPreference);
  }

  _addToUserPreference(){
    if(index == 0){
      Redux.store.dispatch(setUserPreferenece(Redux.store, widget.userId, widget.catId, widget.numShown));
    }
  }

    _swapItems(){
    int newIndex = index + 1;
    int lenKeypoints = _controllerList.length;
    setState(() {
      init = false;
    });
    if(newIndex == lenKeypoints){
      setState(() {
        init = true;
        index = 0;
      });
    }else{
      setState(() {
        index = newIndex;
        init = true;
      });
      _controllerList[newIndex].play();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(index == 0 && _controllerList.length != 0){
      _controllerList[index].play();
    }
    return Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: init?
              GestureDetector(
                child:  AspectRatio(
                  aspectRatio: _controllerList[index].value.aspectRatio,
                  child: VideoPlayer(_controllerList[index]),
                ),
                onTap: (){if(widget.keypoint != null){
                  _swapItems();
                }},
              ):
              Container(
                alignment: Alignment.center,
                height: 50,
                child: 
                  CircularProgressIndicator(),
              ),
          ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   print('==============video dispose===============');
  //   // _controller.dispose();
  // }
}