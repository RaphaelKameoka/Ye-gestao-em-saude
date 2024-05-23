import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ye_project/exam.dart';
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
  Color profileCor = Colors.transparent;
  Color examCor = Colors.grey[350] ?? Colors.grey;
  Color notificationsCor = Colors.transparent;

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

  void _navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName, arguments: {
      'user_name': userName,
      'avatar': avatar,
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget actualHomeScreen = ExamScreen(userName: userName, avatar: avatar);

    switch (widget.nextScreen) {
      case 'chat_with_ai':
        actualHomeScreen = ChatScreen();
        break;
      case "exam":
        actualHomeScreen = ExamScreen(userName: userName, avatar: avatar,);
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
                  _navigateTo('/chat_with_ai');
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: profileCor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        profileCor = Colors.grey[350] ?? Colors.grey;
                        examCor = Colors.transparent;
                        notificationsCor = Colors.transparent;
                      });
                    },
                    icon: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/png/history.png',
                          width: 70,
                          height: 40,
                        ),
                        Text(
                          "Histórico",
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: examCor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        examCor = Colors.grey[350] ?? Colors.grey;
                        profileCor = Colors.transparent;
                        notificationsCor = Colors.transparent;
                      });
                      Future.delayed(const Duration(milliseconds: 50), () {
                        _navigateTo('/exam');
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: notificationsCor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        notificationsCor = Colors.grey[350] ?? Colors.grey;
                        profileCor = Colors.transparent;
                        examCor = Colors.transparent;
                      });
                    },
                    icon: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/png/medication.png',
                          width: 70,
                          height: 40,
                        ),
                        Text(
                          "Medicação",
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
