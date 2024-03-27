import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider/flashcard.dart';
import '../provider/cartes.dart';
import '../provider/flashcards_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadFilePage extends StatefulWidget {

  static const routename = '/publicatondetailscreen';
  final String userId;

  UploadFilePage({Key? key, this.userId}) : super(key: key);

  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  bool _isLoading = false;
  PlatformFile? _pickedFile;
  var uuid = Uuid();
  final _titleController = TextEditingController();
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  void _uploadFile() async {
    if (_pickedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    var uri = Uri.parse('http://127.0.0.1:5000/upload');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromBytes(
        'file',
        _pickedFile!.bytes!,
        filename: _pickedFile!.name,
      ));

   
    var response = await request.send();

    if (response.statusCode == 200) {
 
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      var responses = json.decode(responseString);

    
      List<dynamic> flashcardsJson = responses['flashcards'];
      print(flashcardsJson);

      List<CarteItem> carteItems = flashcardsJson.map((flashcardJson) {
        return CarteItem(
          flashcardid: uuid.v4().toString(),
          question: flashcardJson['question'],
          reponse: flashcardJson['answer'],
        );
      }).toList();

      print(carteItems);

      Flashcard newFlashcard = Flashcard(
        id: DateTime.now().toIso8601String(), 
        title: _titleController.text.isEmpty
            ? 'Imported Flashcards'
            : _titleController
                .text, 
        color: 'blue', 
        isPublic: false,
        flashcards: carteItems,
        sharedWithUserIds: [], 
      );

      print(newFlashcard);


      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.green, content: Text('Flashcards uploaded and added successfully!')),
      );
    } else {

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text('Failed to upload flashcards')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Flashcard Title'),
                  ),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text('Pick File'),
                  ),
                  SizedBox(height: 20),
                  _pickedFile != null
                      ? Text('File: ${_pickedFile!.name}')
                      : Container(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _uploadFile,
                    child: Text('Upload and Process File'),
                  ),
                ],
              ),
      ),
    );
  }
}

