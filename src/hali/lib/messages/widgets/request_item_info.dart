import 'package:flutter/material.dart';
import 'package:hali/models/item_listing_message.dart';

class RequestItemInfo extends StatelessWidget {
  final ItemListingMessage itemListingMessage;

  const RequestItemInfo({Key key, this.itemListingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildRequestItemInfo(itemListingMessage),
    );
  }

  Widget _buildRequestItemInfo(ItemListingMessage itemListingMessage) {
    final itemOwner = itemListingMessage.to.displayName ?? itemListingMessage.to.email;
    final itemTitle = itemListingMessage.content;
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(125.0),
            child: Image.asset(
              "assets/images/hali_logo_199.png",
              height: 32.0,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(                        
            child: Card(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,                
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Trợ lý Hali", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Bạn đang yêu cầu từ $itemOwner $itemTitle"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
