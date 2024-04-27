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
  var actualScreen = "authentication";

  @override
  void switchScreens({required String nextScreen}) {
    actualScreen = nextScreen;
  }

  @override
  Widget build(BuildContext context) {
    Widget screenWidget = AuthBackground();
    return MaterialApp(
      home: Scaffold(
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF6B9683),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/ye_logo.png'),
                fit: BoxFit.none,
                repeat: ImageRepeat.repeat,
                alignment: Alignment.bottomCenter,
                scale: 1.5,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 35),
              Center(
                child: Container(
                  width: 225,
                  height: 225,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/ye_logo_with_name.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 35),
              screenWidget
            ],
          )
        ]),
      ),
    );
  }
}
