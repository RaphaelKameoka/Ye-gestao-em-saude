import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';

class MedicationScreen extends StatefulWidget {
  final String userName;

  const MedicationScreen({required this.userName, super.key});

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class Item {
  Item({
    required this.medication,
    required this.from,
    required this.to,
    required this.interval,
  });

  String medication;
  String from;
  String to;
  String interval;
}


List<Item> generateItems(List<Map<String, dynamic>> dataList) {
  return List<Item>.generate(dataList.length, (int index) {
    return Item(
      medication: dataList[index]['medicacao'] ?? 'N/A',
      from: dataList[index]['inicio'] ?? 'N/A',
      to: dataList[index]['fim'] ?? 'N/A',
      interval: dataList[index]['intervalo'] ?? 'N/A',
    );
  });
}

class _MedicationScreenState extends State<MedicationScreen> {
  final ApiClient apiClient = ApiClient();
  bool _showOverlay = false;
  bool _insertMedication = false;
  late DateTime from;
  late DateTime to;
  int _selectedInterval = 8;
  TextEditingController medicationController = TextEditingController();
  late String fromInput;
  late String toInput;
  List<Item> _data = [];
  List<Map<String, dynamic>> data = [];

  Future<void> _getHistory() async {
    _showGif();
    try {
      final http.Response response = await apiClient.post('/get_medication', {
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

  String formatDate(String dateTime) {
    final DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat outputFormat = DateFormat('dd/MM/yyyy');

    DateTime date = inputFormat.parse(dateTime);

    String formattedDate = outputFormat.format(date);

    return formattedDate;
  }

  void _showGif() {
    setState(() {
      _showOverlay = true;
    });
  }

  Future<void> _handleCadastrarPressed() async {
    try {
      setState(() {
        _showOverlay = true;
      });
      final http.Response response = await apiClient.post('/insert_medication', {
        'medication': medicationController.text,
        'interval': _selectedInterval,
        'as_from': transformDateFormat(from.toString()).toString(),
        'to': transformDateFormat(to.toString()).toString(),
        'user_name': widget.userName
      });
      if (response.statusCode == 200) {
        setState(() {
          _showOverlay = false;
          _insertMedication = false;
        });
        _getHistory();
      } else {
        print("Algo deu errado");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String transformDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
    DateFormat outputFormat = DateFormat('MM/dd/yy HH:mm:ss');

    DateTime dateTime = inputFormat.parse(inputDate);

    String outputDate = outputFormat.format(dateTime);

    return outputDate;
  }

  @override
  void initState() {
    _getHistory();
    from = DateTime.now();
    to = from.add(Duration(days: 3));
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
                "Medicamentos",
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
                          item.medication,
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF6B9683),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${formatDate(item.from)} - ${formatDate(item.to)}',
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
                      '${item.interval} horas',
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
                  _insertMedication = true;
                });
              },
              icon: const Icon(Icons.add, size: 40),
            ),
          ),
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
                          controller: medicationController,
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
                            to = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              from.hour,
                              from.minute,
                              from.second,
                              from.millisecond,
                              from.microsecond,
                            );
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
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Intervalo entre doses',
                      style: GoogleFonts.montserrat(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
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
                      onPressed: () {
                        _handleCadastrarPressed();
                        },
                      child: Text("Cadastrar medicamento",style: GoogleFonts.montserrat(
                          color: Colors.black, fontWeight: FontWeight.bold)),
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
