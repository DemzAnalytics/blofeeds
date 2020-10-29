import 'package:blofeeds/store/reducers/authreducer.dart';
import 'package:blofeeds/store/reducers/commonreducer.dart';
import 'package:blofeeds/store/reducers/videoreducer.dart';
import 'package:flutter/foundation.dart';

@immutable
class SetAuthStateAction {
  final AuthState authState;

  SetAuthStateAction(this.authState);
}

@immutable
class SetVideosStateAction{
  final VideosState videosState;

  SetVideosStateAction(this.videosState);
}

@immutable
class SetCommonStateAction{
  final CommonState commonState;

  SetCommonStateAction(this.commonState);
}