import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

class AppointmentsScreen extends StatefulWidget {
  final String userName;

  const AppointmentsScreen({required this.userName, super.key});

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class Item {
  Item({
    required this.type,
    required this.adress,
    required this.date,
  });

  String type;
  String adress;
  String date;
}

List<Item> generateItems(List<Map<String, String>> dataList) {
  return List<Item>.generate(dataList.length, (int index) {
    return Item(
      type: dataList[index]['type'] ?? 'N/A',
      adress: dataList[index]['adress'] ?? 'N/A',
      date: dataList[index]['date'] ?? 'N/A',
    );
  });
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Item> _data = [];
  final ApiClient apiClient = ApiClient();
  bool _showOverlay = false;
  bool _insertAppointment = false;
  late DateTime today;

  void _showGifClick() {
    setState(() {
      _showOverlay = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showOverlay = false;
      });
    });
  }

  @override
  void initState() {
    today = DateTime.now();
    super.initState();
    List<Map<String, String>> dataList = [
      {
        'type': 'Sangue',
        'adress': 'Rua Antonio Santos',
        'date': '20/06/2024'
      },
    ];
    _data = generateItems(dataList);
    _showGifClick();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.12,
            color: const Color.fromARGB(255, 241, 241, 234),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Consultas médicas",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6B9683),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 22),
          Column(
            children: _data.map<Container>((Item item) {
              return Container(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.04, 12, 0, 12),
                color: const Color.fromARGB(255, 241, 241, 234),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.type,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          item.adress,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      item.date,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF6B9683),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromARGB(255, 241, 241, 234),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _insertAppointment = true;
                });
              },
              icon: const Icon(Icons.add, size: 40),
            ),
          ),
        ),
      ),
      if (_showOverlay)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(child: Image.asset('assets/gifs/loading.gif')),
          ),
        ),
      if (_insertAppointment)
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 241, 234),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(vertical: 200),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 225),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Icon(Icons.keyboard_backspace,color: Colors.grey,),
                            iconSize: 35.0,
                            onPressed: () {
                              setState(() {
                                _insertAppointment = false;
                              });
                            }),
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.left,
                      "Endereço",
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 35,
                        child: TextFormField(
                          maxLength: null,

                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[350],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.left,
                      "Tipo de exame",
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 35,
                        child: TextFormField(
                          // controller: emailController,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[350],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Data",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        )),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? dateTime = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(3000),
                        );
                        if (dateTime != null) {
                          setState(() {
                            today = dateTime;
                          });
                        }
                      },
                      child: Text("${today.day}/${today.month}/${today.year}",
                          style: GoogleFonts.montserrat(color: Colors.black)),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsetsDirectional.symmetric(
                              horizontal: 60, vertical: 10),
                        ),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey[350]!,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Cadastrar consulta",style: GoogleFonts.montserrat(
                          color: Colors.black, fontWeight: FontWeight.bold)
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsetsDirectional.symmetric(
                              horizontal: 20, vertical: 20),
                        ),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(107, 150, 131, 1)!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    ]);
  }
}
