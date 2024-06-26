import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ye_project/background/authentication_background.dart';
import 'package:ye_project/background/home_background.dart';
import 'package:ye_project/chat.dart';

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
        '/login_error': (context) => AuthBackground('login_error'),
        '/forgot_password': (context) => AuthBackground('forgot_password'),
        '/forgot_password_error': (context) => AuthBackground('forgot_password_error'),
        '/create_account': (context) => AuthBackground('create_account'),
        '/create_account_error': (context) => AuthBackground('create_account_error'),
        '/password_code': (context) => AuthBackground('password_code'),
        '/password_code_error': (context) => AuthBackground('password_code_error'),
        '/change_password': (context) => AuthBackground('change_password'),
        '/change_password_error': (context) => AuthBackground('change_password_error'),
        '/chat_with_ai': (context) => ChatScreen(),
        '/exam': (context) => HomeBackground('exam'),
        '/history': (context) => HomeBackground('history'),
        '/medication': (context) => HomeBackground('medication'),
      },
    );
  }
}
