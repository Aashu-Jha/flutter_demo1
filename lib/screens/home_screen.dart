import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo1/widgets/image_preview_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Assignment'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            //To avoid orientation error, we are using singleChildScrollView
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  ImagePreviewWidget(imageFile: _imageFile),
                  const SizedBox(height: 20),
                  if (_imageFile == null)
                    ElevatedButton(
                      onPressed: () => _pickImageFromGallery(),
                      child: Text('Select Image'),
                    ),
                ],
              ),
            ),
          )),
          ElevatedButton.icon(
              style: TextButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                backgroundColor: Theme.of(context).accentColor,
                elevation: 0,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => uploadImage(_imageFile, context),
              icon: Icon(Icons.add),
              label: Text(
                'Upload Image',
                style: TextStyle(fontSize: 20),
              )),
        ],
      ),
    );
  }

  Future<void> uploadImage(File? image, BuildContext ctx) async {
    if (image == null) {
      showSnackBar(ctx, 'Please select image first');
      return;
    }

    final postUri = Uri.parse('https://codelime.in/api/remind-app-token');
    final request = new http.MultipartRequest("POST", postUri);

    request.fields['image'] = 'example';
    request.files.add(
      new http.MultipartFile.fromBytes(
        'file',
        await image.readAsBytes(),
        contentType: new MediaType('image', 'jpeg'),
      ),
    );

    request.send().then((response) {
      if (response.statusCode == 200) {
        showSnackBar(ctx, 'File successfully uploaded!');
      }
      ;
    });
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      //If the user return without select any image, this condition will be fired
      //We can return bool and show the user a snackbar if it's false
      if (pickedFile == null) {
        print('Try again');
        return;
      }
      setState(() {
        this._imageFile = File(pickedFile.path);
      });
    } catch (e) {
      this._imageFile = null;
      print(e);
    }
  }

  void showSnackBar(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}
