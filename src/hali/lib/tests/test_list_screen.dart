import 'package:flutter/material.dart';
import 'package:hali/messages/request_listing_confirmation_screen.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/user_profile.dart';
import 'package:uuid/uuid.dart';

class TestListScreen extends StatefulWidget {
  TestListScreen({Key key}) : super(key: key);

  @override
  _TestListScreenState createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  static final uuid = Uuid();
  final List<ItemListingMessage> itemListing = List.generate(10, (int index) {
    return ItemListingMessage.fromNamed(
        status: ItemRequestMessageStatus.Open,
        itemType: "food",
        itemId: uuid.v1(),
        itemTitle: "Item name $index",
        itemImageUrl:
            "https://firebasestorage.googleapis.com/v0/b/hali-ca190.appspot.com/o/public_images%2FTomato_PNG_Clipart_Picture.png?alt=media&token=9e3605a8-3209-4750-8cbc-e06a16d96b17",
        from: UserProfile.fromNamed(
            displayName: "Thinh Hua Quang",
            imageUrl:
                "https://lh3.googleusercontent.com/a-/AAuE7mA61feM1gOmpGCrIUYJz0azUwI6buQOaWVRok0RGw=s96-c",
            userId: "VVrhTSFPzvUP2Bsb6na2vgrFlp52",
            email: "hquangthinh@gmail.com",
            isActive: true),
        to: UserProfile.fromNamed(
            displayName: "Tomato",
            imageUrl: "https://api.adorable.io/avatars/100/abott@adorable.png",
            userId: "y41Rrmr7A0gzniC9kSudv6RmeA62",
            email: "brtometh@gmail.com",
            isActive: true),
        isSeen: false,
        publishedAt: DateTime.now());
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: buildScreenBody(),
      ),
    );
  }

  Widget buildScreenBody() {
    return ListView.builder(
      itemCount: itemListing.length,
      itemBuilder: (context, index) {
        final item = itemListing[index];
        return ListTile(
          leading: Icon(Icons.fastfood),
          title: Text(item.itemTitle),
          trailing: RaisedButton(
            child: Text(
              "Request Item",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blueAccent,
            onPressed: () {
              _requestItem(item);
            },
          ),
        );
      },
    );
  }

  _requestItem(ItemListingMessage item) {
    // 1) open request listing confirmation screen
    // 2) on confirmed at confirmation screen send a message from requestor to owner
    // 3) Then goes to message screen
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequestListingConfirmationScreen(
              requestItem: item,
            )));
  }
}
