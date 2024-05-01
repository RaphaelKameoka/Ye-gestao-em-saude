import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() {
    return _CreateAccountState();
  }
}

class _CreateAccountState extends State<CreateAccount> {
  bool obscureTextPassword = true;
  bool obscureTextConfirmation = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 35,
        ),
        Column(
          children: [
            Text(
              "Criar conta",
              style: GoogleFonts.montserrat(fontSize: 60, height: 1.2),
            ),
            SizedBox(
              width: 300,
              child: Text(
                "Crie sua conta para continuar",
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                style: GoogleFonts.montserrat(
                    fontSize: 15, color: Colors.grey, height: 0.5),
              ),
            ),
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
                  child: TextFormField(
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
                SizedBox(height: 15),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Senha",
                        style: GoogleFonts.montserrat(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.top,
                          obscureText: obscureTextPassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureTextPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureTextPassword = !obscureTextPassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[350],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ]),
                SizedBox(height: 15),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Confirmar senha",
                        style: GoogleFonts.montserrat(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.top,
                          obscureText: obscureTextConfirmation,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureTextConfirmation ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureTextConfirmation = !obscureTextConfirmation;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[350],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 35,
                ),
                FilledButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsetsDirectional.symmetric(
                              horizontal: 20, vertical: 14)),
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
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsetsDirectional.symmetric(
                            horizontal: 60, vertical: 10)),
                  ),
                  child: Text(
                    "Ja possui uma conta?",
                    style: GoogleFonts.montserrat(
                        color: Colors.blue, fontSize: 17),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
