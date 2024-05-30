import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'custom_expansion_panel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

List<String> exams = <String>['Pressão', 'Glicemia', 'Peso', 'IMC'];

class HistoryScreen extends StatefulWidget {
  final String userName;

  const HistoryScreen({required this.userName, super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String dropdownValue = exams.first;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.1,
        color: const Color.fromARGB(255, 241, 241, 234),
        child: Container(
          alignment: Alignment.center,
          child: DropdownButton<String>(
            value: dropdownValue,
            style: GoogleFonts.montserrat(
              color: const Color(0xFF6B9683),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            alignment: Alignment.center,
            isExpanded: true,
            dropdownColor: const Color.fromARGB(255, 241, 241, 234),
            iconEnabledColor: Colors.transparent,
            icon: null,
            iconSize: 0,
            elevation: 1,
            itemHeight: 65.0,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },

            items: exams.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value), alignment: Alignment.center,);
            }).toList(),
          ),
        ),
      ),
    ]));
  }
}
