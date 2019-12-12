import 'package:cached_network_image/cached_network_image.dart';
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
              : CachedNetworkImage(
                imageUrl: postModel.imageUrl ?? "",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                )),
    );
  }

  bool isDirtyImage() {
    return !this.postModel.imageUrl.contains("https");
  }
}
