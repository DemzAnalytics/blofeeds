import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:blofeeds/main.dart';
import 'package:blofeeds/store/actions/actionType.dart';
import 'package:blofeeds/store/actions/index.dart';
import 'package:blofeeds/store/index.dart';
import 'package:blofeeds/store/reducers/authreducer.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget{
  @override
  _SplashScreenState createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen>{
  var store = Redux.store;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), _pushScreen);
  }

  void _pushScreen() async{
    final expires = await getSharedPreference('expires');
    var date = DateTime.now();
    if(expires==null){
      navigatorKey.currentState.pushReplacementNamed('/login');
    }else if(date.isAfter(DateTime.parse(expires))){
      navigatorKey.currentState.pushReplacementNamed('/login');
    }else{
      final auth = await getSharedPreference('authData');
      var authData = json.decode(auth);
      final accessToken = authData['access_token'];
      if(authData['args'].isEmpty){
        store.dispatch(getVideos(store, accessToken, 0));
      }else{
        store.dispatch(SetAuthStateAction(AuthState(auth: authData)));
        store.dispatch(getRecommendedCategory(store, accessToken, authData['args']));
      }
      navigatorKey.currentState.pushReplacementNamed('/feeds');
    }
  }

  @override
  Widget build(BuildContext context){
    return(
      Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image(image: AssetImage('lib/images/logo.png'), height: 100, width: 100)
        ),
      )
    );
  }
}