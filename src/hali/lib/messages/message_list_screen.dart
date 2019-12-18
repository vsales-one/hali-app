import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_widgets/empty_listing.dart';
import 'package:hali/messages/widgets/message_card_item_widget.dart';
import 'package:hali/models/item_listing_message.dart';
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
    return StreamBuilder(
      stream: RepositoryProvider.of<ChatMessageRepository>(context)
          .getItemRequestMessages(),
      builder: (context, snapshot) {
        print(">>>>>>> connectionState: ${snapshot.connectionState}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return EmptyListing(
            noDataMessage: "Chưa có tin nhắn nào dành cho bạn",
          );
        }

        List<ItemListingMessage> chats = snapshot.data;
        if (chats == null || chats.isEmpty) {
          return EmptyListing(
            noDataMessage: "Chưa có tin nhắn nào dành cho bạn",
          );
        }

        return ListView.builder(
          itemBuilder: (context, index) => MessageCardItemWidget(
            requestMessage: chats[index],
          ),
          itemCount: chats.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
        );
      },
    );
  }
}
