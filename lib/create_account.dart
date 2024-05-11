import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'api.dart';


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

  final ApiClient apiClient = ApiClient();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  Future<void> _handleCriarPressed() async {

    try {

      final String email = emailController.text;
      final String senha = senhaController.text;
      final String confirm_password = confirmController.text;


      final http.Response response = await apiClient.post('/create_user',{
        'email': email,
        'password': senha,
        'confirm_password': confirm_password
      });

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/login');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  
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
                    controller: emailController,
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
                          controller: senhaController,
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
                          controller: confirmController,
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
                    onPressed: () {
                      _handleCriarPressed();
                    },
                    child: Text(
                      "Criar",
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
