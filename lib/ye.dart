import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ye_project/login_page.dart';

class Ye extends StatefulWidget{
  @override
  State<Ye> createState(){
    return _YeState();
  }
}

class _YeState extends State<Ye>{
  var actualScreen = "login-page";

  @override
  void switchScreens({required String nextScreen}){
    actualScreen = nextScreen;
}

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = LoginPage();
    return MaterialApp(
      home: Scaffold(
        body: screenWidget
      ),
    );
  }
}