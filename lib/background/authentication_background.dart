import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ye_project/forgot_password.dart';
import 'package:ye_project/login_screen.dart';

class AuthBackground extends StatefulWidget {
  AuthBackground(this.nextScreen, {super.key});

  String nextScreen;
  @override
  State<AuthBackground> createState() {
    return _AuthBackgroundState();
  }
}

class _AuthBackgroundState extends State<AuthBackground> {
  Widget actualAuthScreen = LoginScreen();

  @override
  Widget build(BuildContext context) {

    switch(widget.nextScreen){
      case 'login':
        setState(() {
          actualAuthScreen = LoginScreen();
        });

        break;
      case 'forgot_password':
        setState(() {
          actualAuthScreen = ForgotPassword();
        });
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      height: (MediaQuery.of(context).size.height - 295),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255,241,241,234),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(90),
        ),
      ),
      child: actualAuthScreen,
      );
  }
}
