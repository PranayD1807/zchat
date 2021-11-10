import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatImgPicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  const ChatImgPicker(this.imagePickFn);

  @override
  State<ChatImgPicker> createState() => _ChatImgPickerState();
}

class _ChatImgPickerState extends State<ChatImgPicker> {
  final ImagePicker _picker = ImagePicker();
  File? _storedImage;
  //image from camera
  _imgFromCamera() async {
    XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 720,
    );
    if (pickedImage != null) {
      setState(() {
        _storedImage = File(pickedImage.path);
      });
      widget.imagePickFn(_storedImage!);
    } else {
      return;
    }
  }

  //image from gallery
  _imgFromGallery() async {
    XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
    );
    if (pickedImage != null) {
      setState(() {
        _storedImage = File(pickedImage.path);
      });
      widget.imagePickFn(_storedImage!);
    } else {
      return;
    }
  }

  //show picker function
  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  child: IconButton(
                    iconSize: 40,
                    icon: const Icon(Icons.photo_camera),
                    onPressed: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                CircleAvatar(
                  radius: 40,
                  child: IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.photo_library),
                      onPressed: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _showPicker(context);
      },
      icon: const Icon(
        Icons.photo,
        color: Colors.white,
      ),
    );
  }
}
