import 'package:blofeeds/store/actions/actionType.dart';
import 'package:blofeeds/store/reducers/commonreducer.dart';

class AuthState{
  Map auth;

  AuthState({this.auth});

  factory AuthState.initial()=>AuthState(
    auth: {},
  );

  AuthState copyWith({Map auth, CommonState common}){
    return AuthState(
      auth: auth ?? this.auth,
    );
  }
}

authReducer(AuthState state, SetAuthStateAction action){
  final payload = action.authState;
  return state.copyWith(
    auth:payload.auth, 
  );
}