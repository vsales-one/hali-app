import 'package:flutter/material.dart';
import 'package:hali/app_widgets/user_widget.dart';
import 'package:hali/config/application.dart';
import 'package:hali/messages/message_screen.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/models/user_profile.dart';

class RecentChatWidget extends StatefulWidget {
  final ChatMessage chat;
  const RecentChatWidget({Key key, this.chat}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecentChatWidgetState();
}

class _RecentChatWidgetState extends State<RecentChatWidget> {
  @override
  void initState() {
    assert(this.widget.chat != null &&
        this.widget.chat.from != null &&
        this.widget.chat.to != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MessageScreen(
                  friend: friend,
                )));
      },
      leading: UserWidget(
        user: friend,
      ),
      title: Text(
        friend.displayName,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        widget.chat.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  UserProfile get friend => widget.chat.from.id == Application.currentUser.id
      ? widget.chat.to
      : widget.chat.from;
}
