import 'package:blofeeds/statefulWidgets/login.dart';
import 'package:blofeeds/statefulWidgets/signup.dart';
import 'package:blofeeds/statefulWidgets/homescreen.dart';
import 'package:blofeeds/store/index.dart';
import 'package:blofeeds/store/reducers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() async{
  await Redux.init();
  runApp(MyApp());
}

Color textcolor= const Color(0xFF49A1FF);
Color inputcolor = const Color(0xFF5D5D5D);
Color primarycolor = const Color(0xFF007BFF);

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return StoreProvider<AppState>(
      store: Redux.store, 
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'BloFeeds',
        initialRoute: '/login',
        routes: {
          '/login': (context) => Login(),
          '/signup': (context) => SignUp(),
          '/feeds': (context) => HomeScreen()
        },
      )
    );
  }
}