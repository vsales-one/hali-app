import 'package:flutter/material.dart';
import 'package:hali/app_widgets/user_widget.dart';
import 'package:hali/config/application.dart';
import 'package:hali/messages/message_screen.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/user_profile.dart';

class RecentChatWidget extends StatefulWidget {
  final ItemListingMessage requestMessage;
  const RecentChatWidget({Key key, this.requestMessage}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecentChatWidgetState();
}

class _RecentChatWidgetState extends State<RecentChatWidget> {
  @override
  void initState() {
    assert(this.widget.requestMessage != null &&
        this.widget.requestMessage.from != null &&
        this.widget.requestMessage.to != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MessageScreen(
                  friend: friend, itemRequestMessage: widget.requestMessage,
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
        widget.requestMessage.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  UserProfile get friend =>
      widget.requestMessage.from.userId == Application.currentUser.userId
          ? widget.requestMessage.to
          : widget.requestMessage.from;
}
