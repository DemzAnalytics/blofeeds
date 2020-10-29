import 'package:blofeeds/store/actions/actionType.dart';
import 'package:blofeeds/store/reducers/commonreducer.dart';

class VideosState{
  Map data;
  int page;

  VideosState({this.data, this.page});

  factory VideosState.initial()=>VideosState(
    data: {},
    page: 1,
  );

  VideosState copyWith({Map data, int page, CommonState common}){
    return VideosState(
      data: data ?? this.data,
      page: page ?? this.page,
    );
  }
}

videosReducer(VideosState state, SetVideosStateAction action){
  final payload = action.videosState;
  return state.copyWith(
    data:payload.data, 
    page: payload.page,
  );
}