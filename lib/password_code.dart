import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class PasswordCode extends StatefulWidget {
  const PasswordCode({super.key});

  @override
  State<PasswordCode> createState() {
    return _PasswordCodeState();
  }
}

class _PasswordCodeState extends State<PasswordCode> {
  
  bool obscureText = true;
  final ApiClient apiClient = ApiClient();

  TextEditingController codeController = TextEditingController();

  Future<void> _handleEnviarPressed() async {
    try {
      final ModalRoute? modalRoute = ModalRoute.of(context);
      if (modalRoute != null) {
        final Map<String, dynamic>? args = modalRoute.settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          final String email = args['email'] as String;
          final String code = codeController.text;

          final http.Response response = await apiClient.post('/check_code',{
            'email': email,
            'confirmation_code': code
          });

          if (response.statusCode == 200) {
            Navigator.pushNamed(
              context, 
              '/change_password',
              arguments: {'email': email},
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
          height: 35,
        ),
        Column(
          children: [
            Text(
              "Código de confirmação",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: 40),
            ),
            SizedBox(
              width: 200,
              child: Text(
                "Insira o código que foi enviado em seu email",
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                style: GoogleFonts.montserrat(
                    fontSize: 15, color: Colors.grey, height: 1),
              ),
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Código",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextFormField(
                    controller: codeController,
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
                const SizedBox(height: 50),
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
                      _handleEnviarPressed();
                    },
                    child: Text(
                      "Confirmar",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 25),
                    )),
                SizedBox(height: 30),
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
