import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';

class UploadFromGallery extends StatelessWidget {
  final VoidCallback openGallery;
  final File image;
  
  UploadFromGallery({this.openGallery, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: FlatButton(
          onPressed: openGallery,
          child: Text(
            "Chọn ảnh từ thư viện",
            style: image == null
                ? Styles.getRegularStyle(14, Colors.blueGrey)
                : Styles.getRegularStyle(14, Colors.white),
          )),
    );
  }
}
