import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ye_project/profile.dart';

class HomeBackground extends StatefulWidget {
  HomeBackground(this.nextScreen, {super.key});

  final String nextScreen;

  @override
  State<HomeBackground> createState() {
    return _HomeBackgroundState();
  }
}

class _HomeBackgroundState extends State<HomeBackground> {
  Color consultaCor = Colors.transparent;
  Color examCor = Colors.transparent;
  Color medicationCor = Colors.transparent;

  late String userName;

  @override
  void initState() {
    super.initState();
    userName = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getUserNameFromArguments();
  }

  void _getUserNameFromArguments() {
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      final Map<String, dynamic>? args = modalRoute.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          userName = args['user_name'] as String;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget actualHomeScreen = ProfileScreen(userName: userName);

    switch (widget.nextScreen) {
      case 'profile':
        setState(() {
          actualHomeScreen = ProfileScreen(userName: userName);
        });
        break;
    }
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              color: const Color(0xFF6B9683),
            ),
          ),
          Positioned.fill(child: actualHomeScreen),
        ],
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 241, 241, 234),
        height: 80,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: consultaCor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        consultaCor = Colors.grey[350] ?? Colors.grey;
                        examCor = Colors.transparent;
                        medicationCor = Colors.transparent;
                      });
                    },
                    icon: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/png/profile.png',
                          width: 70,
                          height: 40,
                        ),
                        Text(
                          "Perfil",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            SizedBox(width: 17),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: examCor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        examCor = Colors.grey[350] ?? Colors.grey;
                        consultaCor = Colors.transparent;
                        medicationCor = Colors.transparent;
                      });
                    },
                    icon: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/png/medical_exam.png',
                          width: 70,
                          height: 40,
                        ),
                        Text(
                          "Exames",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            SizedBox(width: 17),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: medicationCor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        medicationCor = Colors.grey[350] ?? Colors.grey;
                        consultaCor = Colors.transparent;
                        examCor = Colors.transparent;
                      });
                    },
                    icon: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/png/bell.png',
                          width: 70,
                          height: 40,
                        ),
                        Text(
                          "Lembretes",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}