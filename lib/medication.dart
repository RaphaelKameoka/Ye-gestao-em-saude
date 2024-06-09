import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

class MedicationScreen extends StatefulWidget {
  final String userName;

  const MedicationScreen({required this.userName, super.key});

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class Item {
  Item({
    required this.medication,
    required this.period,
    required this.interval,
  });

  String medication;
  String period;
  String interval;
}

List<Item> generateItems(List<Map<String, String>> dataList) {
  return List<Item>.generate(dataList.length, (int index) {
    return Item(
      medication: dataList[index]['medication'] ?? 'N/A',
      period: dataList[index]['period'] ?? 'N/A',
      interval: dataList[index]['interval'] ?? 'N/A',
    );
  });
}

class _MedicationScreenState extends State<MedicationScreen> {
  List<Item> _data = [];
  final ApiClient apiClient = ApiClient();
  bool _showOverlay = false;
  bool _insertMedication = false;
  late DateTime from;
  late DateTime to;
  int _selectedInterval = 8;

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
    from = DateTime.now();
    to = from.add(Duration(days: 30));
    super.initState();
    List<Map<String, String>> dataList = [
      {
        'medication': 'Paracetamol',
        'period': '30/05/2024 - 20/06/2024',
        'interval': '8 horas'
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
            height: MediaQuery.of(context).size.height * 0.1,
            color: const Color.fromARGB(255, 241, 241, 234),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Medicamentos",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFF6B9683),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
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
                          item.medication,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          item.period,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      item.interval,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF6B9683),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
                  _insertMedication = true;
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
      if (_insertMedication)
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
                margin: EdgeInsets.symmetric(vertical: 160),
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
                                _insertMedication = false;
                              });
                            }),
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.left,
                      "Nome do medicamento",
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
                    Text("De",
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
                            from = dateTime;
                          });
                        }
                      },
                      child: Text("${from.day}/${from.month}/${from.year}",
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
                    Text("Até",
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
                            to = dateTime;
                          });
                        }
                      },
                      child: Text("${to.day}/${to.month}/${to.year}",
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
                      height: 15,
                    ),
                    Text(
                      'Intervalo entre doses',
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton<int>(
                        value: _selectedInterval,
                        padding:
                            const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        icon: null,
                        iconSize: 0,
                        elevation: -1,
                        items: <int>[4, 6, 8, 12, 24].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value horas'),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          setState(() {
                            _selectedInterval = newValue!;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 65,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Cadastrar medicamento",style: GoogleFonts.montserrat(
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
