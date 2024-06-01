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

class Item {
  Item({
    required this.date,
    required this.values,
    required this.condition,
  });

  String date;
  String values;
  String condition;
}

List<Item> generateItems(List<Map<String, String>> dataList) {
  return List<Item>.generate(dataList.length, (int index) {
    return Item(
      date: dataList[index]['date'] ?? 'N/A',
      values: dataList[index]['values'] ?? 'N/A',
      condition: dataList[index]['condition'] ?? 'N/A',
    );
  });
}

class _HistoryScreenState extends State<HistoryScreen> {
  String dropdownValue = exams.first;
  List<Item> _data = [];

  @override
  void initState() {
    super.initState();
    List<Map<String, String>> dataList = [
      {'date': '20/05/2024', 'values': '12/8', 'condition': 'Normal'},
      {'date': '10/03/2024', 'values': '11/8', 'condition': 'Normal'},
      {'date': '02/01/2024', 'values': '17/11', 'condition': 'Elevado'},
    ];
    _data = generateItems(dataList);
  }

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
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                    alignment: Alignment.center,
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: _data.map<Container>((Item item) {
              return Container(
                padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.02, 12, 0, 12),
                color: const Color.fromARGB(255, 241, 241, 234),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          item.values,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          item.condition,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.5),
                    Text(
                      item.date,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF6B9683),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
