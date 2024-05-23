import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {

  bool obscureText = true;
  final ApiClient apiClient = ApiClient();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();


Future<void> _handleEntrarPressed() async {
  try {
    final String email = emailController.text;
    final String senha = senhaController.text;

    final http.Response response = await apiClient.post('/login', {
      'email': email,
      'password': senha,
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      if (responseData.isNotEmpty) {
        final List<List<dynamic>> usersData = List<List<dynamic>>.from(responseData);
        final String? firstUserUserName = usersData[0][0] as String?;
        final String? firstUserAvatar = usersData[0][1] as String?;

        Navigator.pushNamed(
          context, 
          '/exam',
          arguments: {
            'email': email,
            'avatar': firstUserAvatar,
            'user_name': firstUserUserName,
          },
        );
      } else {
        print('User not found or incorrect credentials.');
      }
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
                  "Email ou Nome do Usuário",
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
                const SizedBox(height: 20),
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
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
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
                    onPressed: _handleEntrarPressed,
                    child: Text(
                      "Entrar",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 25),
                    )),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
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
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/create_account');
                        },
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
                              ]),
                        ))
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
