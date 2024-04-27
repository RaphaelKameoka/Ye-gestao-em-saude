import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Text(
              "Login",
              style: GoogleFonts.montserrat(fontSize: 60),
            ),
            Text("Entre para continuar",
                style: GoogleFonts.montserrat(
                    fontSize: 15, color: Colors.grey, height: 0.2)
            ),
            SizedBox(height: 25),
            Container(
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Email",
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[350],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Senha",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    obscureText: true,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.remove_red_eye_outlined, color: Colors.grey,),
                      filled: true,
                      fillColor: Colors.grey[350],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ],
    );
  }
}
