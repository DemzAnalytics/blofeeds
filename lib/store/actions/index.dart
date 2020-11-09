import 'dart:convert';
import 'package:blofeeds/main.dart';
import 'package:blofeeds/store/actions/actionType.dart';
import 'package:blofeeds/store/reducers/authreducer.dart';
import 'package:blofeeds/store/reducers/commonreducer.dart';
import 'package:blofeeds/store/reducers/index.dart';
import 'package:blofeeds/store/reducers/videoreducer.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// 10.0.2.2
final url = 'https://ds4.bloverse.com/v2';
// final url = 'http://10.0.2.2:9000/v2';

Future<void> loginUser(Store<AppState> store, payload, context) async{
  store.dispatch(SetCommonStateAction(CommonState(loadding: true)));
  try{
    Map data = {'username': payload};
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(url+'/sign-in/'),
        body: body,
        headers: {'Content-Type': 'application/json; charset=utf-8'});

    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
    var jsonData;
    if (response.body.isNotEmpty) {
      jsonData = json.decode(response.body);
    }

    if(response.statusCode == 200){
      var date = DateTime.now();
      final finalDate = date.add(Duration(seconds: jsonData['data']['expires']));
      await setNonMapSharedPreference('expires', finalDate);
      await setSharedPreference('authData', jsonData['data']);
      navigatorKey.currentState.pushReplacementNamed('/feeds');
      await store.dispatch(SetAuthStateAction(AuthState(auth: jsonData['data'])));
      await store.dispatch(SetCommonStateAction(CommonState(expires: jsonData['data']['expires'])));
      if(jsonData['data']['args'].length == 0){
        await store.dispatch(getVideos(store, jsonData['data']['access_token'], 0));
      }else{
        await store.dispatch(getRecommendedCategory(store, jsonData['data']['access_token'], jsonData['data']['args']));
      }
      
    }else{
      store.dispatch(SetCommonStateAction(CommonState(error: jsonData['message'])));
    }
  }catch(error){
    store.dispatch(SetCommonStateAction(CommonState(error: error.toString(), loadding: false)));
  }
}

Future<void> signUpUser(Store<AppState> store, payload, context) async{
  store.dispatch(SetCommonStateAction(CommonState(loadding: true)));
  try{
    Map data = {'username':payload};
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(url+'/sign-up/'),
        body: body,
        headers: {'Content-Type': 'application/json; charset=utf-8'});  

    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
    var jsonData;
    if (response.body.isNotEmpty) {
      jsonData = json.decode(response.body);
    }
    
    if(response.statusCode == 201){
      var date = DateTime.now();
      final finalDate = date.add(Duration(seconds: jsonData['data']['expires']));
      await setNonMapSharedPreference('expires', finalDate);
      await setSharedPreference('authData', jsonData['data']);
      navigatorKey.currentState.pushReplacementNamed('/feeds');
      await store.dispatch(SetAuthStateAction(AuthState(auth: jsonData['data'])));
      await store.dispatch(SetCommonStateAction(CommonState(expires: jsonData['data']['expires'])));
      await store.dispatch(getVideos(store, jsonData['data']['access_token'], 0));
    }else{
      store.dispatch(SetCommonStateAction(CommonState(error: 'error')));
    }
  }catch(error){
    store.dispatch(SetCommonStateAction(CommonState(error: error.toString(), loadding: false)));
  }
}

Future<void> getVideos(Store<AppState> store, String accessToken, int catId) async{
  store.dispatch(SetCommonStateAction(CommonState(loadding: true)));
  final pageNo = store.state.videosState.page;

  try{
    final response = await http.get(
        Uri.parse(url+'/feeds?page='+ pageNo.toString() + '&cat_id=' + catId.toString()), 
        headers: {'Authorization': 'Bearer ' + accessToken, 'Keep-Alive': 'true'});
    
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
    final jsonData = json.decode(response.body);

    if(response.statusCode == 200){
      print('======got here======');
      await store.dispatch(SetVideosStateAction(VideosState(page: pageNo+1, data: jsonData['data'])));
    }else{
      store.dispatch(SetCommonStateAction(CommonState(error: 'error')));
    }
  }catch(error){
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
  }
}

Future<void> getRecommendedCategory(Store<AppState> store, String accessToken, Map data) async{
  store.dispatch(SetCommonStateAction(CommonState(loadding: true)));

  try{
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(url+'/personalize'),
        body: body,
        headers: {'Authorization': 'Bearer ' + accessToken});
    
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
    final jsonData = json.decode(response.body);

    if(response.statusCode == 201){
      int id = int.parse(jsonData['data']['id']);
      print('ppppppppptttt');
      await store.dispatch(getVideos(store, accessToken, id));
    }else{
      store.dispatch(SetCommonStateAction(CommonState(error: '')));
    }
  }catch(error){
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
  }
}

Future<void> setUserPreferenece(Store<AppState> store, String userId, int catId, int numShown) async{
  final accessToken = store.state.authState.auth['access_token'];
  try{
    var body = jsonEncode(numShown);
    final response =await http.patch(
      url+'/user-category/'+userId+'/'+catId.toString(),
      body: body,
      headers: {'Authorization': 'Bearer ' + accessToken}
    );

    if(response.statusCode == 201){
      store.dispatch(getUserPreference(store, userId));
    }

  }catch (error){
    print('========error setting preference========');
    print(error);
  }
}

Future<void> getUserPreference(Store<AppState> store, String userId) async{
final accessToken = store.state.authState.auth['access_token'];
  try{
    final response =await http.get(
      url+'/user-category?user='+userId,
      headers: {'Authorization': 'Bearer ' + accessToken}
    );
    final jsonData = json.decode(response.body);

    if(response.statusCode == 200){
      final auth = await getSharedPreference('authData');
      auth['args'] = jsonData['data'];
      store.state.authState.auth = auth;
      await setSharedPreference('authData', auth);
    }

  }catch (error){
    print('========error getting preference========');
    print(error);
  }
}

Future<void> setSharedPreference(String preference, dynamic data) async{
  String serilizedData = json.encode(data);
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(preference, serilizedData);
}

Future<void> setNonMapSharedPreference(String preference, dynamic data) async{
  String serilizedData = data.toString();
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(preference, serilizedData);
}

Future<dynamic> getSharedPreference(String preference) async{
  final prefs = await SharedPreferences.getInstance();
  final data  = prefs.getString(preference)?? null;
  return data;
}