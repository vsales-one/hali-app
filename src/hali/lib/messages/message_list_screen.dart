import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_widgets/recent_chat_widget.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/repositories/chat_message_repository.dart';

class MessageListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMessageList(context);
  }  

  Widget _buildMessageList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamBuilder(
          stream:
              RepositoryProvider.of<ChatMessageRepository>(context).getItemRequestMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<ChatMessage> chats = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) => RecentChatWidget(
                chat: chats[index],
              ),
              itemCount: chats.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            );
          },
        )
      ],
    );
  }
}
