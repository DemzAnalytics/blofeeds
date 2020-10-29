
import 'package:blofeeds/main.dart';
import 'package:blofeeds/store/actions/index.dart';
import 'package:blofeeds/store/index.dart';
import 'package:blofeeds/store/reducers/authreducer.dart';
import 'package:blofeeds/store/reducers/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignUp extends StatefulWidget{
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>{
  String _username = '';
  
  _signupUser(){
    Redux.store.dispatch(signUpUser(Redux.store, _username, widget));  
  }

  void _setPassword(val){
    setState(() {
      _username = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    var state = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, AuthState>(
      converter: (store)=>store.state.authState,
      builder: (context, authState){
      return Center(
      child: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('lib/images/logo.png'), fit: BoxFit.cover, alignment: Alignment.center)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 20, left: 20)),
                  Image.asset('lib/images/logo.png', width: 50, height: 50),
                  Text(
                    'Feeds', 
                    textAlign: TextAlign.center,
                    style: TextStyle(decoration: TextDecoration.none, fontSize: 18, color: Colors.white, fontStyle: FontStyle.italic))
                ],)),
            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(right: 21, left: 21),
                  padding: EdgeInsets.all(5),
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(37),
                          child: Text(
                          'Bloverse Feeds',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: textcolor),
                          ),
                        ),
                        state.state.commonState.error != ''?
                          Container(
                          child: Text(
                         state.state.commonState.error,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, color: textcolor),
                          ),
                        ):Container(),
                        Container(
                          padding: EdgeInsets.all(12),
                          height: 100,
                          width: 520,
                          child: TextField(
                            onChanged: (val){_setPassword(val);},
                            style: TextStyle(color: inputcolor),
                            decoration: InputDecoration(
                              labelText: 'Username',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 0.8),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 11),
                          padding: EdgeInsets.all(11),
                          alignment: Alignment.center,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent, width: 1), borderRadius: BorderRadius.circular(7)),
                            color: primarycolor,
                            onPressed: () {_signupUser();},
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(18),
                            elevation: 1,
                            child: Text(
                              'SignUp',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(bottom: 10),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Login',
                              style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: textcolor),
                              recognizer: TapGestureRecognizer()..onTap=(){Navigator.pushNamed(context, '/login');},
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            )
          ]
        ),
      )
    );
      }
    );
  }
}