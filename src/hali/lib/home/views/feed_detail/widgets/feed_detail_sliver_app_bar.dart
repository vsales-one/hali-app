import 'package:flutter/material.dart';
import 'package:hali/models/post_model.dart';

class FeedDetailSliverAppBar extends StatelessWidget {
  final PostModel postModel;

  FeedDetailSliverAppBar({this.postModel});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text("",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
          background: (postModel.imageUrl == null || isDirtyImage())
              ? Image.asset("assets/images/placeholder.kpg")
              : Image.network(
                  postModel.imageUrl ?? "",
                  fit: BoxFit.cover,
                )),
    );
  }

  bool isDirtyImage() {
    return !this.postModel.imageUrl.contains("https");
  }
}
