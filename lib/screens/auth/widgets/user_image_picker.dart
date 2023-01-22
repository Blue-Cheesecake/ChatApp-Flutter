import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key, required this.assignImageFileFunc})
      : super(key: key);

  final Function(XFile imageXfile) assignImageFileFunc;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _image;
  final _imagePicker = ImagePicker();

  void _pickImage() async {
    XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _image = picked;
    });

    if (picked != null) {
      widget.assignImageFileFunc(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Image Avatar
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.lightBlue,
          backgroundImage: _image == null
              ? null
              : FileImage(
                  File(_image!.path),
                ),
        ),

        TextButton(
          onPressed: _pickImage,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Add Image",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.image_rounded),
            ],
          ),
        ),
      ],
    );
  }
}
