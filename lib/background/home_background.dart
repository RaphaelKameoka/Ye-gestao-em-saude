import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ye_project/exam.dart';
import 'package:ye_project/chat.dart';
import 'package:ye_project/history.dart';
import 'package:ye_project/medication.dart';


class HomeBackground extends StatefulWidget {
  final String nextScreen;

  HomeBackground(this.nextScreen, {Key? key}) : super(key: key);

  @override
  State<HomeBackground> createState() => _HomeBackgroundState();
}

class _HomeBackgroundState extends State<HomeBackground> {
  late String userName;
  late String avatar;
  int _selectedIndex = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    userName = '';
    avatar = '';
    _pageController =
        PageController(initialPage: 1);
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Container(
              color: const Color(0xFF6B9683),
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              HistoryScreen(userName: userName),
              ExamScreen(userName: userName, avatar: avatar),
              MedicationScreen(userName: userName),
            ],
          ),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 241, 241, 234),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clockRotateLeft, size: 30),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.briefcaseMedical, size: 30,),
            label: 'Exames',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.pills, size: 30),
            label: 'Medicação',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6B9683),
        selectedLabelStyle: const TextStyle(color: Color(0xFF6B9683)),
        onTap: _onItemTapped,
      ),
    );
  }
}

