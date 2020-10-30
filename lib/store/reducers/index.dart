import 'package:blofeeds/store/actions/actionType.dart';
import 'package:blofeeds/store/reducers/authreducer.dart';
import 'package:blofeeds/store/reducers/commonreducer.dart';
import 'package:blofeeds/store/reducers/videoreducer.dart';
import 'package:flutter/cupertino.dart';

@immutable
class AppState {
  final AuthState authState;
  final VideosState videosState;
  final CommonState commonState;

  AppState({this.authState, this.videosState, this.commonState});

  AppState copyWith({AuthState authState, VideosState videosState, CommonState commonState}) {
    return AppState(
      authState: authState ?? this.authState,
      videosState: videosState ?? this.videosState,
      commonState: commonState ?? this.commonState
    );
  }
}

AppState appReducer(AppState state, dynamic action) {
    if (action is SetAuthStateAction) {
      final nextAuthState = authReducer(state.authState, action);
      return state.copyWith(authState: nextAuthState);
    }else if(action is SetVideosStateAction){
      final nextVideosState = videosReducer(state.videosState, action);
      return state.copyWith(videosState: nextVideosState);
    }else if(action is SetCommonStateAction){
      final nextCommonState = commonReducer(state.commonState, action);
      return state.copyWith(commonState: nextCommonState);
    }
    return state;

}
