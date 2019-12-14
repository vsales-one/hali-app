import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FeedBodyImage extends StatelessWidget {
  final VoidCallback onTap;
  final String id;
  final String imageUrl;

  const FeedBodyImage({Key key, this.onTap, this.imageUrl, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widthImage = MediaQuery.of(context).size.width - 128;
    return GestureDetector(
      child: Container(
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: _buildImage(widthImage),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildImage(double widthImage) {
    return Hero(
      tag: "${Uuid().v1()}@{$id}",
      child: CachedNetworkImage(
        width: widthImage,
        height: widthImage,
        imageUrl: imageUrl ?? "",
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }
}
