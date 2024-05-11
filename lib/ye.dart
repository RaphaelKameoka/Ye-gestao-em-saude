import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ye_project/background/authentication_background.dart';
import 'package:ye_project/login_screen.dart';

class Ye extends StatefulWidget {
  @override
  State<Ye> createState() {
    return _YeState();
  }
}

class _YeState extends State<Ye> {

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = AuthBackground('login');
    return MaterialApp(
      home: screenWidget,
      routes: {
        '/login': (context) => AuthBackground('login'),
        '/forgot_password': (context) => AuthBackground('forgot_password'),
        '/create_account': (context) => AuthBackground('create_account'),
        '/password_code': (context) => AuthBackground('password_code'),
        '/change_password': (context) => AuthBackground('change_password'),
      },
    );
  }
}
