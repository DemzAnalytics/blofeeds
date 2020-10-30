import 'package:blofeeds/statelessWidgets/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListItem extends StatefulWidget{
  const ListItem({Key key, this.keypoint, this.headline, this.userId}) : super(key: key);

  final List keypoint;
  final String headline;
  final String userId;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  List _keypoints;
  int index;

  @override
  void initState() {
    super.initState();
    _keypoints = widget.keypoint;
    setState(() {
      _keypoints.insert(0, widget.headline);
      index = 0;
    });
  }

  _swapItems(){
    int newIndex = index + 1;
    int lenKeypoints = _keypoints.length;
    print('--------index of item-------------');
    print(index);
    print(newIndex);
    print(lenKeypoints);
    print('--------index of item-------------');
    setState(() {
      if(newIndex == lenKeypoints){
        index = 0;
      }else{
        index = newIndex;
      }
    });
  }

  _renderPoints(){
    List<Widget> points = [];
    if(_keypoints != null){
      for (var i =0; i< _keypoints.length; i++) {
        var item = _keypoints[i];
        points.add(
            GestureDetector(
              // child: VideoPLayer(
              //   url: item,
              //   userId: widget.userId,
              //   numShown: i+1,
              // ),
              onTap: (){
                if(_keypoints != null){
                  _swapItems();
                }
              },
            )
        );
      }
    }
    
    return points;
  }

  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return IndexedStack(
      index: index,
      children: _renderPoints(),
      sizing: StackFit.expand,
    );  
  }

  @override
  void dispose(){
    super.dispose();
  }
}