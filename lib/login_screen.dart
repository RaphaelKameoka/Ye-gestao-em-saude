import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState(){
    return _LoginScreenState();
  }
}


class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
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
                    fontSize: 15, color: Colors.grey, height: 0.2)),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Email",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey, fontWeight: FontWeight.bold),
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
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Senha",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    obscureText: true,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.grey[350],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                FilledButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsetsDirectional.symmetric(
                              horizontal: 60, vertical: 10)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      alignment: Alignment.center,
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromRGBO(107, 150, 131, 1)),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Entrar",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 25),
                    )),
                SizedBox(height: 20),
                TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: Text(
                      "Esqueceu a senha?",
                      style: GoogleFonts.montserrat(
                          color: Colors.blue, fontSize: 17),
                    ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){},
                        child: RichText(
                            text: TextSpan(
                              text: "Não tem uma conta?",
                              style: GoogleFonts.montserrat(
                                  color: Colors.black, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                  text: " Cadastre-se aqui!",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.blue, fontSize: 15),
                                )
                              ]
                            ),
                        )
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
