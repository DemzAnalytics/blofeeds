import 'package:blofeeds/store/reducers/authreducer.dart';
import 'package:blofeeds/store/reducers/commonreducer.dart';
import 'package:blofeeds/store/reducers/videoreducer.dart';
import 'package:redux/redux.dart';
import 'package:blofeeds/store/reducers/index.dart';
import 'package:redux_thunk/redux_thunk.dart';

class Redux {
  static Store<AppState> _store;

  static Store <AppState> get store {
    if (_store == null) {
      throw Exception("store is not initialized");
    } else {
      return _store;
    }
  }

  static Future<void> init() async {
    final commonStateInitial = CommonState.initial();
    final authStateInitial = AuthState.initial();
    final videosStateInitial = VideosState.initial();
    _store = Store<AppState>(
      appReducer,
      middleware: [thunkMiddleware],
      initialState: AppState(commonState: commonStateInitial, authState: authStateInitial, videosState: videosStateInitial),
    );
  }
}