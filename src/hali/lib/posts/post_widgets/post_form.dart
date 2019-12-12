import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hali/posts/post_widgets/create_food_form.dart';

class PostForm extends StatelessWidget {
  final File image;
  final String postImageUrl;

  PostForm({@required this.image, @required this.postImageUrl});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 900,
        child: CreateFoodForm(imageCover: image, postImageUrl: postImageUrl,),
      )
    );
  }
}