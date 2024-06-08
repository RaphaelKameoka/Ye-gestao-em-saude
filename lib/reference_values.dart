import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferenceValues extends StatelessWidget {
  const ReferenceValues({super.key});

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 15),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: "Pressão arterial:\n\n",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 1,)
              ),
              TextSpan(
                text: " Baixa: menor que 9/6 \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.orange,
                  fontSize: 17,
                  height: 0.6,
                ),
              ),
              TextSpan(
                text: " Ótima: menor que 12/8 \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.green,
                  fontSize: 17,
                  height: 0.6,
                ),
              ),
              TextSpan(
                text: " Normal: entre 12/8 e 13/8 \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.yellow[600],
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Atenção: entre 13/9 e 14/9 \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.orange,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Alta: maior do que 14/9 \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontSize: 17,
                  height: 1,
                ),),
              TextSpan(
                  text: "Glicemia em jejum:\n\n",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 1,)
              ),
              TextSpan(
                text: " Baixa: menor do que 70 mg/dL \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.orange,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Normal: abaixo de 100 mg/dL \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.green,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Atenção: entre 100 e 126 mg/dL \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.orange,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Alta: acima de 126 mg/dL \n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontSize: 17,
                  height: 1,
                ),),
              TextSpan(
                  text: "IMC:\n\n",
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 1,)
              ),
              TextSpan(
                text: " Abaixo do peso: menor que 18,5\n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.orange,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Normal: entre 18,5 e 24,9\n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.green,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Sobrepeso: entre 25 e 29,9\n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.yellow,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Obesidade I: entre 30 e 34,6\n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.orange,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Obesidade II: entre 35 e 39,9\n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontSize: 17,
                  height: 0.6,
                ),),
              TextSpan(
                text: " Obesidade grave: acima de 40\n\n",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 17,
                  height: 0.6,
                ),),
            ],
          ),

        ),
      ],
    );
  }
}