import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';

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
    required this.time
  });

  String type;
  String adress;
  String date;
  String time;
}

List<Item> generateItems(List<Map<String, dynamic>> dataList) {
  return List<Item>.generate(dataList.length, (int index) {
    return Item(
      type: dataList[index]['type'] ?? 'N/A',
      adress: dataList[index]['adress'] ?? 'N/A',
      date: dataList[index]['date'] ?? 'N/A',
      time: dataList[index]['hour'] ?? 'N/A'
    );
  });
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Item> _data = [];
  final ApiClient apiClient = ApiClient();
  bool _showOverlay = false;
  bool _insertAppointment = false;
  List<Map<String, dynamic>> data = [];
  late DateTime today;
  late TimeOfDay now;
  TextEditingController adressController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  Future<void> _getHistory() async {
    _showGif();
    try {
      final http.Response response = await apiClient.post('/get_appointment', {
        'user_name': widget.userName,
      });
      if (response.statusCode == 200) {
        setState(() {
          _showOverlay = false;
          data = List<Map<String, dynamic>>.from(jsonDecode(response.body));;
          _data = generateItems(data);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _handleCadastrarPressed() async {
    _showGif();
    try {
      final http.Response response = await apiClient.post('/insert_appointments', {
        'adress': adressController.text,
        'type': typeController.text,
        'as_from': transformDateFormat(today.toString()).toString(),
        'hour': formatHours(now.hour, now.minute),
        'user_name': widget.userName
      });
      if (response.statusCode == 200) {
        setState(() {
          _showOverlay = false;
          _insertAppointment = false;
        });
        _getHistory();
      } else {
        print("Algo deu errado");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String formatHours(int hour, int minute) {
    final now = DateTime.now();
    final formattedTime = DateTime(now.year, now.month, now.day, hour, minute);
    final DateFormat formatter = DateFormat('MM/dd/yy HH:mm:ss');
    return formatter.format(formattedTime);
  }


  String transformDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
    DateFormat outputFormat = DateFormat('MM/dd/yy HH:mm:ss');

    DateTime dateTime = inputFormat.parse(inputDate);

    String outputDate = outputFormat.format(dateTime);

    return outputDate;
  }

  void _showGif() {
    setState(() {
      _showOverlay = true;
    });
  }

  @override
  void initState() {
    _getHistory();
    today = DateTime.now();
    now = TimeOfDay.now();
    super.initState();
    _data = generateItems(data);
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
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          item.date,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          item.time,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
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
                margin: const EdgeInsets.symmetric(vertical: 200),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 225),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: const Icon(Icons.keyboard_backspace,color: Colors.grey,),
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
                          controller: adressController,
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
                      "Tipo",
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 35,
                        child: TextFormField(
                          controller: typeController,
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
                        padding: WidgetStateProperty.all(
                          EdgeInsetsDirectional.symmetric(
                              horizontal: 60, vertical: 10),
                        ),
                        shape:
                        WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.grey[350]!,
                        ),
                      ),
                    ),
                    Text("Hora",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        )),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? dateTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (dateTime != null) {
                          setState(() {
                            now = dateTime;
                          });
                        }
                      },
                      child: Text("${today.hour}:${today.minute}",
                          style: GoogleFonts.montserrat(color: Colors.black)),
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsetsDirectional.symmetric(
                              horizontal: 60, vertical: 10),
                        ),
                        shape:
                        WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.grey[350]!,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print(now.toString());
                        _handleCadastrarPressed();
                      },
                      child: Text("Cadastrar consulta",style: GoogleFonts.montserrat(
                          color: Colors.black, fontWeight: FontWeight.bold)
                      ),
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsetsDirectional.symmetric(
                              horizontal: 20, vertical: 20),
                        ),
                        shape:
                        WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color.fromRGBO(107, 150, 131, 1),
                        ),
                      ),
                    ),
                  ],
                ),
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
    ]);
  }
}
