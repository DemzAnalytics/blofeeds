import 'package:blofeeds/main.dart';
import 'package:blofeeds/statelessWidgets/videosplayer.dart';
import 'package:blofeeds/store/reducers/index.dart';
import 'package:blofeeds/store/reducers/videoreducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    var state = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, VideosState>(
      converter: (store)=>store.state.videosState,
      builder: (context, videosState){
      return Center(
        child: Container(
          color: Colors.white,
          child: videosState.data.isEmpty?
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            color: primarycolor,
            child: state.state.commonState.loadding? 
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
            ): Container(

            )
          ):
           ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videosState.data.isEmpty?0: videosState.data['articles'].length,
            // controller: ScrollController(initialScrollOffset: 0.5),
            itemBuilder: videosState.data.isEmpty?
            (BuildContext context){
              return Center(
                child: Container(
                  child: Text(
                  'Empty'
                )),
              );
            }:
            (BuildContext context, int index){
              Map keypoint = videosState.data['articles'][index]['subclip_urls'];
              return Container(
                child: VideosPlayer(
                  userId: state.state.authState.auth['username'],
                  keypoint: keypoint,
                  numShown: index+1,
                  catId: videosState.data['articles'][index]['Category'],
                )
              );
            }
          ),
        ),
      );
      }
    );
  }
}