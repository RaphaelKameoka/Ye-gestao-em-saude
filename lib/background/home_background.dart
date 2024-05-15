import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBackground extends StatefulWidget {
  HomeBackground(this.nextScreen, {super.key});

  String nextScreen;
  @override
  State<HomeBackground> createState() {
    return _HomeBackgroundState();
  }
}

class _HomeBackgroundState extends State<HomeBackground> {
  Color consultaCor = Colors.transparent;
  Color examCor = Colors.transparent;
  Color medicationCor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Color(0xFF6B9683),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 241, 241, 234),
        height: 85,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  color: consultaCor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (consultaCor == Colors.transparent) {
                        consultaCor = Colors.grey[350] ?? Colors.grey;
                      }
                      examCor = Colors.transparent;
                      medicationCor = Colors.transparent;
                    });
                  },
                  icon: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/png/medical_appointment.png',
                        width: 80,
                        height: 50,
                      ),
                      Text(
                        "Consultas",
                        style: GoogleFonts.montserrat(
                          color: Color(0xFF6B9683),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                ),
              ),
            ]),
            SizedBox(width: 5),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  color: examCor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (examCor == Colors.transparent) {
                        examCor = Colors.grey[350] ?? Colors.grey;
                      }
                      consultaCor = Colors.transparent;
                      medicationCor = Colors.transparent;
                    });
                  },
                  icon: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/png/medical_exam.png',
                        width: 80,
                        height: 50,
                      ),
                      Text(
                        "Exames",
                        style: GoogleFonts.montserrat(
                          color: Color(0xFF6B9683),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                ),
              ),
            ]),
            SizedBox(width: 5),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  color: medicationCor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (medicationCor == Colors.transparent) {
                        medicationCor = Colors.grey[350] ?? Colors.grey;
                      }
                      consultaCor = Colors.transparent;
                      examCor = Colors.transparent;
                    });
                  },
                  icon: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/png/medication.png',
                        width: 80,
                        height: 50,
                      ),
                      Text(
                        "Medicação",
                        style: GoogleFonts.montserrat(
                          color: Color(0xFF6B9683),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  splashColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
