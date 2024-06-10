import 'package:flutter/material.dart';
import 'package:ye_project/background/authentication_background.dart';
import 'package:ye_project/background/home_background.dart';

class Ye extends StatefulWidget {
  @override
  State<Ye> createState() {
    return _YeState();
  }
}

class _YeState extends State<Ye> {

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = const AuthBackground('login');
    return MaterialApp(
      home: screenWidget,
      routes: {
        '/login': (context) => const AuthBackground('login'),
        '/login_error': (context) => const AuthBackground('login_error'),
        '/forgot_password': (context) => const AuthBackground('forgot_password'),
        '/forgot_password_error': (context) => const AuthBackground('forgot_password_error'),
        '/create_account': (context) => const AuthBackground('create_account'),
        '/create_account_error': (context) => const AuthBackground('create_account_error'),
        '/password_code': (context) => const AuthBackground('password_code'),
        '/password_code_error': (context) => const AuthBackground('password_code_error'),
        '/change_password': (context) => const AuthBackground('change_password'),
        '/change_password_error': (context) => const AuthBackground('change_password_error'),
        '/chat_with_ai': (context) => const HomeBackground('chat_with_ai'),
        '/exam': (context) => const HomeBackground('exam'),
        '/history': (context) => const HomeBackground('history'),
        '/alarms': (context) => const HomeBackground('alarms'),


      },
    );
  }
}
