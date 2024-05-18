import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({super.key,required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 90),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              userName, // Display the fetched username
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
