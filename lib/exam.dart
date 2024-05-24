import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';
import 'custom_expansion_panel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:io';

class ExamScreen extends StatefulWidget {
  final String userName;
  final String? avatar;

  const ExamScreen({required this.userName, required this.avatar, super.key});

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final List<Item> _data = generateItems(1);
  String? _avatar;
  final ApiClient apiClient = ApiClient();
  String peso = "";
  String altura = "";
  String pressao = "";
  String glicemia = "";
  String imc = "";

  @override
  void initState() {
    super.initState();
    _avatar = widget.avatar;
    _getExams();
  }


  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      setState(() {
        _avatar = base64Image;
      });

      await _uploadImage(base64Image);
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage(String base64Image) async {
    try {
      final http.Response response = await apiClient.post('/upload_avatar', {
        'user_name': widget.userName,
        'avatar': base64Image,
      });

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
        imc = data['imc'];
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
        item.isExpanded = !item.isExpanded;
      });
    });
    _getExams();
  }

  Future<void> _handleAddButtonPressed() async {
    await _pickImageForText();
  }

  Future<void> _pickImageForText() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      await _sendImageForText(base64Image);
    }
  }

  Future<void> _sendImageForText(String base64Image) async {
    try {
      final http.Response response = await apiClient.post('/get_text', {
        'user_name': widget.userName,
        'image_b64': base64Image,
      });

      if (response.statusCode == 200) {
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 100),
            GestureDetector(
              onTap: () => _showImageSourceActionSheet(context),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                child: _avatar != null && _avatar!.isNotEmpty
                    ? ClipOval(
                        child: Image.memory(
                          base64Decode(_avatar!),
                          fit: BoxFit.cover,
                          width: 160,
                          height: 160,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 140,
                        color: Colors.white,
                      ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.userName,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 162, 162, 0),
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
                        headerBuilder:
                            (BuildContext context, bool isExpanded) {
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
                                    isExpanded ? Icons.remove : Icons.add),
                                onTap: _expand,
                              )
                            ],
                          );
                        },
                        body: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
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
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
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
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 217, 217, 217),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
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
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
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
                            SizedBox(height: 30)
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
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromARGB(255, 241, 241, 234),
              ),
              child: IconButton(
                onPressed: _handleAddButtonPressed,
                icon: Icon(Icons.add, size: 40),
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
