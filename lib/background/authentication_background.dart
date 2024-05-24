import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ye_project/change_password.dart';
import 'package:ye_project/create_account.dart';
import 'package:ye_project/forgot_password.dart';
import 'package:ye_project/login_screen.dart';
import 'package:ye_project/password_code.dart';

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
    switch (widget.nextScreen) {
      case 'login':
        setState(() {
          actualAuthScreen = const LoginScreen();
        },);

        break;
      case 'forgot_password':
        setState(() {
          actualAuthScreen = const ForgotPassword();
        });
        break;
      case 'create_account':
        setState(() {
          actualAuthScreen = const CreateAccount();
        });
      case 'password_code':
        setState(() {
          actualAuthScreen = const PasswordCode();
        });
      case 'change_password':
        setState(() {
          actualAuthScreen = const ChangePassword();
        });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20),
              height: (MediaQuery.of(context).size.height - 295),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 241, 241, 234),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(90),
                ),
              ),
              child: actualAuthScreen,
            )
          ],
        )
      ]),
    );
  }
}
