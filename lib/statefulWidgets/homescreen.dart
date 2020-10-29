import 'package:blofeeds/statelessWidgets/listitem.dart';
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
        print(videosState.data);
      return Center(
        child: Container(
          color: Colors.white,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videosState.data.isEmpty?0: videosState.data['articles'].length,
            itemBuilder: videosState.data.isEmpty?(BuildContext conter, int index){
              return Container();
            }: (BuildContext conter, int index){
                if(videosState.data['articles'] == []){
                  print('llllllllllll');
                  return Container();
                }else{
                  print(videosState.data['articles']);
                  return ListItem(
                    userId: state.state.authState.auth['username'],
                    headline: videosState.data['articles'][index]['subclip_urls']['Vertical']['headline'],
                    keypoint: videosState.data['articles'][index]['subclip_urls']['Vertical']['keypoints'],
                  );
                }
              }
            ),
        ),
      );
      }
    );
  }
}