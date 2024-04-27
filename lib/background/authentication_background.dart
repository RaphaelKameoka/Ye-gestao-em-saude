import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ye_project/login_screen.dart';

class AuthBackground extends StatefulWidget {
  const AuthBackground({super.key});

  @override
  State<AuthBackground> createState() {
    return _AuthBackgroundState();
  }
}

class _AuthBackgroundState extends State<AuthBackground> {
  var actualAuthScreen = "login-page";

  @override
  void switchAuthScreens({required String nextScreen}) {
    actualAuthScreen = nextScreen;
  }

  @override
  Widget build(BuildContext context) {
    Widget actualLoginScreen = LoginScreen();

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
      child: actualLoginScreen,
      );
  }
}
