import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ye_project/profile.dart';
import 'package:ye_project/chat.dart';

class HomeBackground extends StatefulWidget {
  HomeBackground(this.nextScreen, {Key? key}) : super(key: key);

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
  late String avatar;

  @override
  void initState() {
    super.initState();
    userName = '';
    avatar = '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getFromArguments();
  }

  void _getFromArguments() {
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      final Map<String, dynamic>? args =
          modalRoute.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          userName = args['user_name'] as String? ?? '';
          avatar = args['avatar'] as String? ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget actualHomeScreen = ProfileScreen(userName: userName, avatar: avatar);

    switch (widget.nextScreen) {
      case 'login':
        actualHomeScreen = ProfileScreen(userName: userName, avatar: avatar);
        break;
      case 'chat_with_ai':
        actualHomeScreen = ChatScreen();
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
          if (widget.nextScreen != "chat_with_ai")
            Positioned(
              bottom: 60,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/chat_with_ai', arguments: {
                    'user_name': userName,
                    'avatar': avatar
                  });
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 46, 100, 180),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/png/ai-stars.png',
                      width: 60,
                      height: 70,
                    ),
                  ),
                ),
              ),
            ),
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
                      Navigator.pushNamed(context, '/profile', arguments: {
                        'user_name': userName,
                        'avatar': avatar
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
