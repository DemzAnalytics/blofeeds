import 'package:blofeeds/store/actions/actionType.dart';

class CommonState{
  String error;
  bool loadding;
  int expires;

  CommonState({this.expires, this.loadding, this.error});

  factory CommonState.initial()=>CommonState(
    loadding: false,
    expires: 0,
    error: ''
  );

  CommonState copyWith({String error, bool loadding, int expires}){
    return CommonState(
      error: error ?? this.error,
      loadding: loadding ?? this.loadding,
      expires: expires ?? this.expires
    );
  }
}

commonReducer(CommonState state, SetCommonStateAction action){
  final payload = action.commonState;
  return state.copyWith(
    error: payload.error,
    loadding:payload.loadding, 
    expires:payload.expires
  );
}