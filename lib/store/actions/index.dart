import 'dart:convert';
import 'package:blofeeds/main.dart';
import 'package:blofeeds/store/actions/actionType.dart';
import 'package:blofeeds/store/reducers/authreducer.dart';
import 'package:blofeeds/store/reducers/commonreducer.dart';
import 'package:blofeeds/store/reducers/index.dart';
import 'package:blofeeds/store/reducers/videoreducer.dart';
import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

// 10.0.2.2
final url = 'https://ds4.bloverse.com/v2';

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
      print('ok');
      print( jsonData['data']['args'].runtimeType);
      navigatorKey.currentState.pushNamed('/feeds');
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
    store.dispatch(SetCommonStateAction(CommonState(error: error, loadding: false)));
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
      navigatorKey.currentState.pushNamed('/feeds');
      await store.dispatch(SetAuthStateAction(AuthState(auth: jsonData['data'])));
      await store.dispatch(SetCommonStateAction(CommonState(expires: jsonData['data']['expires'])));
      await store.dispatch(getVideos(store, jsonData['data']['access_token'], 0));
    }else{
      store.dispatch(SetCommonStateAction(CommonState(error: 'error')));
    }
  }catch(errorMsg){
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
  }
}

Future<void> getVideos(Store<AppState> store, String accessToken, int catId) async{
  store.dispatch(SetCommonStateAction(CommonState(loadding: true)));
  final pageNo = store.state.videosState.page;
  print('ppppppppp');

  try{
    final response = await http.get(
        Uri.parse(url+'/feeds?page='+ pageNo.toString() + '&cat_id=' + catId.toString()), 
        headers: {'Authorization': 'Bearer ' + accessToken, 'Keep-Alive': 'true'});
    
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
    final jsonData = json.decode(response.body);
    print(jsonData);

    if(response.statusCode == 200){
      await store.dispatch(SetVideosStateAction(VideosState(page: pageNo+1, data: jsonData['data'])));
    }else{
      store.dispatch(SetCommonStateAction(CommonState(error: 'error')));
    }
  }catch(error){
    print(error);
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
  }
}

Future<void> getRecommendedCategory(Store<AppState> store, String accessToken, Map data) async{
  store.dispatch(SetCommonStateAction(CommonState(loadding: true)));
  print('tttttttttttt');

  try{
    var body = json.encode(data);
    final response = await http.post(
        Uri.parse(url+'/personalize'),
        body: body,
        headers: {'Authorization': 'Bearer ' + accessToken});
    
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
    final jsonData = json.decode(response.body);
    print('=========90');
    print(jsonData);

    if(response.statusCode == 201){
      int id = int.parse(jsonData['data']['id']);
      await store.dispatch(getVideos(store, accessToken, id));
    }else{
      store.dispatch(SetCommonStateAction(CommonState(error: '')));
    }
  }catch(error){
    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
  }
}

Future<void> setUserPreferenece(Store<AppState> store, String userId, int catId, int numShown) async{
  store.dispatch(SetCommonStateAction(CommonState(loadding: true)));
  final accessToken = store.state.authState.auth['access_token'];
  try{
    var body = jsonEncode(numShown);
    final response =await http.patch(
      url+'/user-category/'+userId+'/'+catId.toString(),
      body: body,
      headers: {'Authorization': 'Bearer ' + accessToken}
    );

    store.dispatch(SetCommonStateAction(CommonState(loadding: false)));
    final jsonData = json.decode(response.body);

    if(response.statusCode == 201){
      print(jsonData['data']['message']);
    }else{
      store.dispatch(SetCommonStateAction(CommonState(error: '')));
    }

  }catch (error){
    print(error);
  }
}