import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ye_project/reference_values.dart';
import 'api.dart';
import 'custom_expansion_panel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

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
  String pressao_state = "";
  String glicemia_state = "";
  String imc_state = "";
  bool warning = false;
  Color pressaoClass = Colors.transparent;
  Color glicemiaClass = Colors.transparent;
  Color imcClass = Colors.transparent;
  Color pesoClass = Colors.transparent;
  bool _showOverlay = false;
  bool _showNotes = false;

  @override
  void initState() {
    super.initState();
    _avatar = widget.avatar;
    _getExams();
    _showGifClick();
  }

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

  void _referenceValues(String imc_state, String glicemia_state, String pressao_state) {
    // Verificando o valor da pressão arterial
    setState(() {
      if (pressao_state == 'baixo') {
        warning = true;
        pressaoClass = Colors.yellow;
      } else if (pressao_state == 'otimo') {
        warning = false;
        pressaoClass = Colors.green;
      } else if (pressao_state == 'normal') {
        warning = false;
        pressaoClass = Colors.yellow;
      } else if (pressao_state == 'elevado') {
        warning = true;
        pressaoClass = Colors.orange;
      } else if (pressao_state == 'muito elevado') {
        pressaoClass = Colors.red;
        warning = true;
      } else if (pressao_state == 'criticamente elevado') {
        pressaoClass = Colors.purple;
        warning = true;
      } else {
        pressaoClass = Colors.black;
      }
      //Verificando valores para glicemia
      if (glicemia_state == "baixo") {
        warning = true;
        glicemiaClass = Colors.orange;
      } else if (glicemia_state == "normal") {
        warning = false;
        glicemiaClass = Colors.green;
      } else if (glicemia_state == "elevado") {
        warning = true;
        glicemiaClass = Colors.orange;
      } else if (glicemia_state == "muito elevado") {
        glicemiaClass = Colors.red;
        warning = true;
      } else{
        glicemiaClass = Colors.black;
      }

      //Verificando IMC
      if (imc_state == "magro") {
        warning = true;
        imcClass = Colors.orange;
      }
      else if (imc_state == "normal") {
        warning = false;
        imcClass = Colors.green;
      }
      else if (imc_state == "sobrepeso") {
        warning = true;
        imcClass = Colors.yellow;
      }
      else if (imc_state == "obesidade I") {
        warning = true;
        imcClass = Colors.orange;
      }
      else if (imc_state == "obesidade II") {
        imcClass = Colors.red;
        warning = true;
      }
      else if (imc_state == "obesidade grave"){
        imcClass = Colors.purple;
        warning = true;
      } else {
        imcClass = Colors.black;
      }
      pesoClass = Colors.black;
    });

  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
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
        pressao_state = data['pressao_state'];
        glicemia_state = data['glicemia_state'];
        imc_state = data['imc_state'];
        setState(() {
          _referenceValues(imc_state, glicemia_state, pressao_state);
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
        item.isExpanded = !item.isExpanded;
      });
    });
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
        Positioned(
          top: 20,
          left: 10,
          child: IconButton(
              icon: const Icon(Icons.question_mark),
              iconSize: 35.0,
              onPressed: () {
                setState(() {
                  _showNotes = true;
                });
              }),
        ),
        Positioned(
          top: 20,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.refresh),
            iconSize: 40.0,
            onPressed: () {
              _getExams();
              _showGifClick();
            },
          ),
        ),
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
                    : const Icon(
                        Icons.person,
                        size: 140,
                        color: Colors.white,
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.userName,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const SizedBox(height: 40),
            Visibility(
              visible: warning,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                    ),
                    Text("Recomenda-se a ida ao hospital mais próximo",
                        style: GoogleFonts.montserrat(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  ]),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 162, 162, 0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                                      fontSize: 20),
                                ),
                                leading:
                                    Icon(isExpanded ? Icons.remove : Icons.add),
                                onTap: _expand,
                              )
                            ],
                          );
                        },
                        body: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 217, 217, 217),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                          color: pressaoClass,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  const SizedBox(width: 20)
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 217, 217, 217),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                          color: glicemiaClass,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  SizedBox(width: 20)
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 217, 217, 217),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                          color: pesoClass,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  SizedBox(width: 20)
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 217, 217, 217),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                          color: imcClass,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  const SizedBox(width: 20)
                                ],
                              ),
                            ),
                            const SizedBox(height: 30)
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
                color: const Color.fromARGB(255, 241, 241, 234),
              ),
              child: IconButton(
                onPressed: _handleAddButtonPressed,
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
        if (_showNotes)
          Container(
            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 241, 234),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: 40.0,
                      onPressed: () {
                        setState(() {
                          _showNotes = false;
                        });
                      },
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Valores de referência',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ReferenceValues()
              ],
            ),
          )
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
        headerValue: 'Últimas aferições',
        pressaoValue: 'Pressão',
        glicemiaValue: "Glicemia",
        pesoValue: 'Peso',
        imcValue: "IMC");
  });
}
