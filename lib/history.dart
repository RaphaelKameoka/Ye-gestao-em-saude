import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';

List<String> exams = <String>['Pressao', 'Glicemia', 'Peso', 'IMC'];

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

List<Item> generateItems(List<Map<String, dynamic>> dataList) {
  return List<Item>.generate(dataList.length, (int index) {
    return Item(
      date: dataList[index]['Data'] ?? 'N/A',
      values: dataList[index]['Valores'] ?? 'N/A',
      condition: dataList[index]['Estado'] ?? 'N/A',
    );
  });
}

class _HistoryScreenState extends State<HistoryScreen> {
  String dropdownValue = exams.first;
  List<Item> _data = [];
  final ApiClient apiClient = ApiClient();
  List<Map<String, dynamic>> data = [];
  bool _showOverlay = false;

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

  Future<void> _getHistory() async {
    try {
      final http.Response response = await apiClient.post('/get_previous_exams', {
        'user_name': widget.userName,
        'filtro': dropdownValue,
      });
      if (response.statusCode == 200) {
        setState(() {
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


  @override
  void initState() {
    super.initState();
    _getHistory();
    _data = generateItems(data);
    _showGifClick();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.12,
              color: const Color.fromARGB(255, 241, 241, 234),
              child: Container(
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFF6B9683),
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
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
                      _getHistory();
                      _showGifClick();
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
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.04, 12, 0, 12),
                  color: const Color.fromARGB(255, 241, 241, 234),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.values,
                            style: GoogleFonts.montserrat(
                              color: const Color(0xFF6B9683),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            item.condition,
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
                      SizedBox(width: 15,)
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        if (_showOverlay)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(child: Image.asset('assets/gifs/loading.gif')),
            ),
          ),
      ]
    );

  }
}
