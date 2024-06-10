import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:ye_project/api.dart';

class PasswordCodeError extends StatefulWidget {
  const PasswordCodeError({super.key});

  @override
  State<PasswordCodeError> createState() {
    return _PasswordCodeErrorState();
  }
}

class _PasswordCodeErrorState extends State<PasswordCodeError> {

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

          try {
            final http.Response response = await apiClient.post('/check_code',{
              'email': email,
              'confirmation_code': code,
            });

            if (response.statusCode == 200) {
              Navigator.pushNamed(context, '/change_password', arguments: {'email':email});
            } else {
              Navigator.pushNamed(context, '/password_code_error',
                  arguments: {'email': email});
            }
          } catch (e) {
            print('Error: $e');
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: Colors.red,
                      ),
                      Text("Código inválido",
                          style: GoogleFonts.montserrat(
                              color: Colors.red, fontWeight: FontWeight.bold)),
                    ]),
                const SizedBox(height: 50),

                FilledButton(
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          const EdgeInsetsDirectional.symmetric(
                              horizontal: 20, vertical: 14)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      alignment: Alignment.center,
                      backgroundColor: WidgetStateColor.resolveWith(
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
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                          const EdgeInsetsDirectional.symmetric(
                              horizontal: 60, vertical: 10)),
                      backgroundColor: WidgetStateProperty.all(
                          const Color.fromRGBO(217, 217, 217, 1))),
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
