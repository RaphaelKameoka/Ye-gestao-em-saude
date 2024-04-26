import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>{
  @override
  Widget build(BuildContext context) {
    return  Stack(
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
              alignment: Alignment.center,
              scale: 1.5,
            ),
          ),
        ),
        Positioned(
          top: 60,
          left: (MediaQuery.of(context).size.width - 250) / 2,
          child: Container(
            width: 250,
            height: 250,
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 40),
            height: (MediaQuery.of(context).size.height - 360),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255,241,241,234),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(90),
              ),
            ),
            child: const Text("Login",textAlign: TextAlign.center ,style: TextStyle(fontSize: 60,fontFamily: "Montserrat")),),
        ),
      ],
    );

  }
}