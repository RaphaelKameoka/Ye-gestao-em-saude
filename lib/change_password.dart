import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  bool passwordObscureText = true;
  bool newPasswordObscuretText = true;
  final ApiClient apiClient = ApiClient();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();


  Future<void> _handleTrocarPressed() async {
    try {
      final ModalRoute? modalRoute = ModalRoute.of(context);
      if (modalRoute != null) {
        final Map<String, dynamic>? args = modalRoute.settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          final String email = args['email'] as String;
          final String password = passwordController.text;
          final String confirm_password = confirmController.text;

          final http.Response response = await apiClient.post('/change_pass',{
            'email': email,
            'password': password,
            'confirm_password': confirm_password,
          });

          if (response.statusCode == 200) {
            Navigator.pushNamed(
              context, 
              '/login'
            );
          } else {
            print('Error: ${response.statusCode}');
          }
        } else {
          print('No arguments provided.');
        }
      } else {
        print('No modal route found.');
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
          height: 30,
        ),
        Column(
          children: [
            Text(
              "Redefinir senha",
              style: GoogleFonts.montserrat(fontSize: 40),
            ),
            Text("Insira sua nova senha",
                style: GoogleFonts.montserrat(
                    fontSize: 15, color: Colors.grey, height: 0.2)),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Nova senha",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextFormField(
                    controller: passwordController,
                    textAlignVertical: TextAlignVertical.top,
                    obscureText: passwordObscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordObscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordObscureText = !passwordObscureText;
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
                const SizedBox(height: 20),
                Text(
                  "Confirmar nova senha",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextFormField(
                    controller: confirmController,
                    textAlignVertical: TextAlignVertical.top,
                    obscureText: newPasswordObscuretText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          newPasswordObscuretText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            newPasswordObscuretText = !newPasswordObscuretText;
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
                    onPressed: () {
                      _handleTrocarPressed();
                    },
                    child: Text(
                      "Confirmar",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 25),
                    )),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsetsDirectional.symmetric(
                              horizontal: 60, vertical: 10)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(217, 217, 217, 1))),
                  child: Text(
                    "Cancelar",
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
