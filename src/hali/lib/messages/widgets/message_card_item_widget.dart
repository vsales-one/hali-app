import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hali/app_widgets/user_widget.dart';
import 'package:hali/config/application.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/messages/message_screen.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/user_profile.dart';

class MessageCardItemWidget extends StatefulWidget {
  final ItemListingMessage requestMessage;
  const MessageCardItemWidget({Key key, this.requestMessage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessageCardItemWidgetState();
}

class _MessageCardItemWidgetState extends State<MessageCardItemWidget> {
  @override
  void initState() {
    assert(this.widget.requestMessage != null &&
        this.widget.requestMessage.from != null &&
        this.widget.requestMessage.to != null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.requestMessage;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              friend: friend,
              itemRequestMessage: widget.requestMessage,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            _buildItemImage(model.itemImageUrl, model.isClosed),            
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            model.from.imageUrl ?? kDefaultUserPhotoUrl,
                          ),
                          radius: 16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          friend.displayName,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(model.content),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage(String itemImageUrl, bool isClosedItem) {
    return isClosedItem
        ? Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: itemImageUrl,
                placeholder: (ctx, _) => CircularProgressIndicator(),
                width: 92,
                height: 92,
                fit: BoxFit.fill,
              ),
              ClipRect(
                child: Container(
                  color: Colors.tealAccent,
                  child: Text("Đã nhận", style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          )
        : CachedNetworkImage(
            imageUrl: itemImageUrl,
            placeholder: (ctx, _) => CircularProgressIndicator(),
            width: 92,
            height: 92,
            fit: BoxFit.fill,
          );
  }

  UserProfile get friend =>
      widget.requestMessage.from.userId == Application.currentUser.userId
          ? widget.requestMessage.to
          : widget.requestMessage.from;
}
