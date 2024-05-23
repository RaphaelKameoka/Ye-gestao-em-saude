import 'dart:ffi';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'custom_expansion_panel.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';


class ExamScreen extends StatefulWidget {
  final String userName;

  const ExamScreen({required this.userName, super.key});

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final List<Item> _data = generateItems(1);
  final ApiClient apiClient = ApiClient();
  String peso = "";
  String altura = "";
  String pressao = "";
  String glicemia = "";
  String imc = "";

  Future<void> _getExams() async {
    try {
      final http.Response response = await apiClient.post('/get_exams', {
        'user_name': widget.userName,
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        peso = data['peso'];
        altura = data['altura'];
        pressao = data['pressao'];
        glicemia = data['glicemia'];
        double calcIMC = int.parse(peso) / pow((int.parse(altura) / 100), 2);
        imc = calcIMC.round().toString();
        // imc = String
        setState(() {
          _getExams();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _expand() {
    setState(() {
      _data.forEach((item) {
        _getExams();
        item.isExpanded = !item.isExpanded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60),
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 241, 241, 234),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Container(
              child: CustomExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = !isExpanded;
                  });
                },
                children: _data.map<CustomExpansionPanel>((Item item) {
                  return CustomExpansionPanel(
                    hasIcon: false,
                    backgroundColor: Color.fromARGB(255, 241, 241, 234),
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              item.headerValue,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                            leading: Icon(
                              isExpanded ? Icons.remove : Icons.add
                            ),
                            onTap: _expand,
                          )
                        ],
                      );
                    },
                    body: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 217, 217, 217),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(item.pressaoValue,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              ),
                              Text(pressao,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              SizedBox(width: 20)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 217, 217, 217),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(item.glicemiaValue,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              ),
                              Text(glicemia + " mg/dL",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              SizedBox(width: 20)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 217, 217, 217),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(item.pesoValue,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              ),
                              Text(peso + " kg",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              SizedBox(width: 20)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 217, 217, 217),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(item.imcValue,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ),
                              ),
                              Text(imc,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              SizedBox(width: 20)
                            ],
                          ),
                        ),
                        SizedBox(height: 30,)
                      ],
                    ),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Item {
  Item({
    required this.glicemiaValue,
    required this.pesoValue,
    required this.imcValue,
    required this.pressaoValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String glicemiaValue;
  String pesoValue;
  String imcValue;
  String pressaoValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
        headerValue: 'Exames mais recentes',
        pressaoValue: 'Pressão',
        glicemiaValue: "Glicemia",
        pesoValue: 'Peso',
        imcValue: "IMC");
  });
}
