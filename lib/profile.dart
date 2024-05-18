import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String? avatar;

  const ProfileScreen({Key? key, required this.userName, this.avatar})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _avatar;
  final ApiClient apiClient = ApiClient();


  @override
  void initState() {
    super.initState();
    _avatar = widget.avatar;
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

  Future<void> _uploadImage(String base64Image) async {
    try {
      final http.Response response = await apiClient.post('/upload_avatar', {
        'user_name': widget.userName,
        'avatar': _avatar,
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
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 90),
            GestureDetector(
              onTap: () => _showImageSourceActionSheet(context),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey,
                child: _avatar != null && _avatar!.isNotEmpty
                    ? ClipOval(
                        child: Image.memory(
                          base64Decode(_avatar!),
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.userName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}