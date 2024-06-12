import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ye_project/appointments.dart';
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
    _pageController = PageController(initialPage: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getFromArguments();
  }

  void _getFromArguments() {
    final ModalRoute? modalRoute = ModalRoute.of(context);
    // if (widget.nextScreen == "chat_with_ai"){
    //   setState(() {
    //
    //   });
    // }
    if (modalRoute != null) {
      final Map<String, dynamic>? args = modalRoute.settings.arguments as Map<String, dynamic>?;
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
      backgroundColor: const Color.fromARGB(255, 241, 241, 234),
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
              AppointmentsScreen(userName: userName),
              ChatScreen()
            ],
          ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: const Color.fromARGB(255, 241, 241, 234),
            icon: Icon(FontAwesomeIcons.clockRotateLeft, size: 30),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromARGB(255, 241, 241, 234),
            icon: Icon(FontAwesomeIcons.briefcaseMedical, size: 30),
            label: 'Exames',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromARGB(255, 241, 241, 234),
            icon: Icon(FontAwesomeIcons.pills, size: 30),
            label: 'Medicação',
          ),
          BottomNavigationBarItem(
            backgroundColor: const Color.fromARGB(255, 241, 241, 234),
            icon: Icon(FontAwesomeIcons.calendar, size: 30),
            label: 'Consultas',
          ),
        ],
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF6B9683),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: Color(0xFF6B9683)),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        onTap: _onItemTapped,
      ),
    );
  }
}
