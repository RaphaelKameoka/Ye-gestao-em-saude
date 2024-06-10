import 'package:flutter/material.dart';
import 'package:ye_project/ErrorScreens/Login_error.dart';
import 'package:ye_project/ErrorScreens/change_password_error.dart';
import 'package:ye_project/ErrorScreens/create_account_error.dart';
import 'package:ye_project/ErrorScreens/forgot_password_error.dart';
import 'package:ye_project/ErrorScreens/password_code_error.dart';
import 'package:ye_project/change_password.dart';
import 'package:ye_project/create_account.dart';
import 'package:ye_project/forgot_password.dart';
import 'package:ye_project/login_screen.dart';
import 'package:ye_project/password_code.dart';

class AuthBackground extends StatefulWidget {
  final String nextScreen;

  const AuthBackground(this.nextScreen, {super.key});

  @override
  State<AuthBackground> createState() {
    return _AuthBackgroundState();
  }
}

class _AuthBackgroundState extends State<AuthBackground> {
  late Widget actualAuthScreen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getFromArguments();
  }

  void _getFromArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final error = args?['error'] ?? '';

    switch (widget.nextScreen) {
      case 'login':
        actualAuthScreen = const LoginScreen();
        break;
      case 'login_error':
        actualAuthScreen = LoginErrorScreen();
        break;
      case 'forgot_password':
        actualAuthScreen = const ForgotPassword();
        break;
      case 'forgot_password_error':
        actualAuthScreen = const ForgotPasswordError();
        break;
      case 'create_account':
        actualAuthScreen = const CreateAccount();
        break;
      case 'create_account_error':
        actualAuthScreen = CreateAccountError(error: error);
        break;
      case 'password_code':
        actualAuthScreen = const PasswordCode();
        break;
      case 'password_code_error':
        actualAuthScreen = const PasswordCodeError();
        break;
      case 'change_password':
        actualAuthScreen = const ChangePassword();
        break;
      case 'change_password_error':
        actualAuthScreen = const ChangePasswordError();
        break;
      default:
        actualAuthScreen = const LoginScreen();
        break;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    actualAuthScreen = const LoginScreen(); // Default screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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
              const SizedBox(height: 35),
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
              const SizedBox(height: 35),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height - 295,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 241, 241, 234),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(90),
                  ),
                ),
                child: actualAuthScreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
