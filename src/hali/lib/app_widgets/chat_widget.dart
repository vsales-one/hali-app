import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hali/models/chat_message.dart';

class ChatWidget extends StatelessWidget {
  final ChatMessage chat;
  final bool isReceived;
  final bool showUser;

  const ChatWidget(
      {Key key,
      @required this.chat,
      this.isReceived = false,
      this.showUser = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          child: isReceived
              ? _buildReceivedMessage(context)
              : _buildSentMessage(context),
        ),
      ],
    );
  }

  Widget _buildSentMessage(BuildContext context) {
    Color sendColor = chat.type != ChatMessage.IMAGE ? Color(0xff0084FF) : Colors.white;
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 3 / 4),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: sendColor,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: _buildChatContent(chat),
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context) {
    Color receivedColor = Color(0x99eeeeee);
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          isReceived && showUser
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(chat.from.imageUrl ??
                        'https://api.adorable.io/avatars/100/abott@adorable.png'),
                    radius: 12.0,
                  ),
                )
              : Container(
                  width: 32.0,
                  height: 24.0,
                ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 3 / 4),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: receivedColor,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: _buildChatContent(chat),
          ),
        ],
      ),
    );
  }

  Widget _buildChatContent(ChatMessage chat) {
    return chat.type == ChatMessage.IMAGE
        ? CachedNetworkImage(
            imageUrl: chat.content,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          )
        : Text(
            chat.content,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          );
  }
}
