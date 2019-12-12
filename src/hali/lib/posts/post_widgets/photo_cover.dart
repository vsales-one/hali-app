import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/posts/post_widgets/upload_from_gallery.dart';
import 'package:hali/utils/color_utils.dart';

class PhotoCover extends StatelessWidget {
  final Function openCamera;
  final File image;
  final Function openGallery;

  PhotoCover({this.openCamera, this.image, this.openGallery});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                image == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 80,
                        color: Colors.grey,
                      )
                    : Container(),
                Container(
                  width: 150,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: ColorUtils.hexToColor(colorD92c27),
                      borderRadius: BorderRadius.circular(15)),
                  child: FlatButton(
                      onPressed: openCamera,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                          Text(
                            "Chụp ảnh",
                            style: Styles.getRegularStyle(14, Colors.white),
                          )
                        ],
                      )),
                ),
                UploadFromGallery(
                  openGallery: openGallery,
                  image: image,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              image: DecorationImage(
                  image: image == null
                      ? AssetImage("assets/images/placeholder.jpg")
                      : FileImage(image),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}