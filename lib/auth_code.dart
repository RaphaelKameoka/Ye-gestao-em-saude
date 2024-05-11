import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

class AuthCodeScreen extends StatefulWidget {
  const AuthCodeScreen({super.key});

  @override
  State<AuthCodeScreen> createState() {
    return _AuthCodeScreenState();
  }
}

class _AuthCodeScreenState extends State<AuthCodeScreen> {
  final ApiClient apiClient = ApiClient();
  TextEditingController emailController = TextEditingController();
  TextEditingController authCodeController = TextEditingController();
  
  Future<void> _handleVerificarCodigoPressed() async {
    try {
      final String email = emailController.text;
      final String code = authCodeController.text;

      final http.Response response = await apiClient.post('/check_code',{
        'email': email,
        'confirmation_code': code,
      });

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/change_password');
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
          height: 15,
        ),
        Column(
          children: [
            SizedBox(
              width: 300,
              child: Text(
                "Código de autenticação",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(fontSize: 40),
              ),
            ),
            SizedBox(
              width: 200,
              child: Text(
                "Coloque o código de 6 digitos enviado no seu email",
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
                SizedBox(height: 10),
                Text(
                  "Código",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: TextFormField(
                    controller: authCodeController,
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
                const SizedBox(height: 25),
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
                      _handleVerificarCodigoPressed();
                    },
                    child: Text(
                      "Verificar código",
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
