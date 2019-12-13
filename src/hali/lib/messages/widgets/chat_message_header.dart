import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/models/user_profile.dart';

class ChatMessageHeader extends StatelessWidget {
  final UserProfile user;

  const ChatMessageHeader({Key key, this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildChatMessageHeader(user),
    );
  }

  Widget _buildChatMessageHeader(UserProfile friend) {    
    return Container(
      key: this.key,
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(125.0),
            child: CachedNetworkImage(
              imageUrl: friend.imageUrl ?? kDefaultUserPhotoUrl,
              placeholder: (ctx, _) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: 64,
              height: 64,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              friend.displayName ?? friend.userId,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              friend.email ?? "",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
