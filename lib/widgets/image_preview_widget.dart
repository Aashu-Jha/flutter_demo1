import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  const ImagePreviewWidget({
    Key? key,
    required File? imageFile,
  }) : _imageFile = imageFile, super(key: key);

  final File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      height: 400,
      child: (this._imageFile == null)
          ? const Placeholder()
          : Image.file(
              this._imageFile!,
              fit: BoxFit.cover,
            ),
    );
  }
}
