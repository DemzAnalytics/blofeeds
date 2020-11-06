import 'package:blofeeds/store/actions/actionType.dart';

class AuthState{
  Map auth;
  Map userPref;

  AuthState({this.auth, this.userPref});

  factory AuthState.initial()=>AuthState(
    auth: {},
    userPref: {}
  );

  AuthState copyWith({Map auth, Map userPref}){
    return AuthState(
      auth: auth ?? this.auth,
      userPref: userPref ?? this.userPref
    );
  }
}

authReducer(AuthState state, SetAuthStateAction action){
  final payload = action.authState;
  return state.copyWith(
    auth:payload.auth,
    userPref: payload.userPref 
  );
}