import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final List<Item> _data = generateItems(1);

  void _expand() {
    setState(() {
      _data.forEach((item) {
        item.isExpanded = !item.isExpanded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60),
        SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[index].isExpanded = !isExpanded;
                });
              },
              children: _data.map<ExpansionPanel>((Item item) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(item.headerValue),
                        ),
                      ],
                    );
                  },
                  body: Column(
                    children: [
                      ListTile(
                        title: Text(item.pressaoValue),
                      ),
                      ListTile(
                        title: Text(item.glicemiaValue),
                      ),
                      ListTile(
                        title: Text(item.pesoValue),
                      ),
                      ListTile(
                        title: Text(item.imcValue),
                      ),
                    ],
                  ),

                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              _expand();
            },
            child: Text("Expandir"))
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
    this.isExpanded = true,
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
        pressaoValue: 'pressao',
        glicemiaValue: "glicemia",
        pesoValue: 'Peso',
        imcValue: "imc");
  });

}
