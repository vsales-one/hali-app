
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/messages/request_listing_confirmation_screen.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uuid/uuid.dart';
class FeedDetail extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FeedDetailState();
  }
}

class FeedDetailState extends State<FeedDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: CustomScrollView(
        slivers: <Widget>[
          // sliver app bar
          _VSliverAppBar(),
          _LocationWidget(),
          _TitleWidget(),
          _RequestButton()

        ],
      ),
    );
  }

}

class _VSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text("Collapsing Toolbar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
          background: Image.network(
            "https://images.unsplash.com/photo-1537758069025-b07fb3548d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2752&q=80",
            fit: BoxFit.cover,
          )
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Container(
              padding: EdgeInsets.only(left: 16, top: 20, bottom: 20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("PORSTMORE FEST", style: Styles.getSemiboldStyle(25, Colors.black54), textAlign: TextAlign.center,),
                  ),
                  Text("Cùng Phượt – Hòn Nội (Khánh Hòa) sở hữu bãi tắm đôi duy nhất tại Việt Nam với một bên nóng, một bên lạnh. Nơi đây trở thành địa điểm check-in biển tuyệt vời của du khách.", style: Styles.getRegularStyle(16, Colors.black54), textAlign: TextAlign.left,),
                  Text("Read more...", style: Styles.getRegularStyle(12, Colors.blue),  textAlign: TextAlign.left),
                ],
              ),
            )
          )
        ]
      ),
    );
  }
}



class _LocationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),

            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(top: 70),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(child: Icon(Icons.date_range, color: Colors.black54,), padding: EdgeInsets.only(right: 16),),
                          Expanded(
                            child: Text("Pickup Time: 24 May, 2018, 8h30 AM", style: Styles.getSemiboldStyle(14, Colors.black54),),
                          )

                        ],
                      ),

                      Row(
                        children: <Widget>[
                          Padding(child: Icon(Icons.location_on, color: Colors.black54,), padding: EdgeInsets.only(right: 16),),
                          Expanded(
                            child: Text("92 Nguyen Huu Canh, Sai Gon Pearl, 92 Nguyen Huu Canh, Sai Gon Pearl", style: Styles.getSemiboldStyle(14, Colors.black54),),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Padding(child: Icon(Icons.share, color: Colors.black54,), padding: EdgeInsets.all(8),),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                        ),
                      ),

                      Container(
                        child: Padding(child: Icon(Icons.favorite_border, color: Colors.black54,), padding: EdgeInsets.all(8),),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                )
              ],
            )
          ),
        ],
      )
    );
  }
}

class _RequestButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorUtils.hexToColor(colorD92c27),
          borderRadius: BorderRadius.circular(24)
        ),
        child: Column(
          children: <Widget>[
            FlatButton(
              color: ColorUtils.hexToColor(colorD92c27),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Request listing", style: Styles.getRegularStyle(14, Colors.white),),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.location_on, size: 16, color: Colors.white,),
                        Text("123 km away", style: Styles.getRegularStyle(14, Colors.white),),
                      ],
                    ),
                  )
                ],
              ),
              onPressed: () {
                _requestItem(context, itemListing[Random().nextInt(10)]);
              }
            ),
          ],
        ),
      ),
    );
  }

  _requestItem(BuildContext context, ItemListingMessage item) {    
    // 1) open request listing confirmation screen    
    // 2) on confirmed at confirmation screen send a message from requestor to owner
    // 3) Then goes to message screen
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequestListingConfirmationScreen(
          requestItem: item,
        )));
  }

  // mock data
  static final uuid = Uuid();
  final List<ItemListingMessage> itemListing = List.generate(10, (int index) {
    return ItemListingMessage.fromNamed(
        status: ItemRequestMessageStatus.Open,
        itemType: "food",
        itemId: uuid.v1(),
        itemTitle: "Food item created at ${DateTime.now().toIso8601String()}",
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
            imageUrl:
                "https://api.adorable.io/avatars/100/abott@adorable.png",
            userId: "y41Rrmr7A0gzniC9kSudv6RmeA62",
            email: "brtometh@gmail.com",
            isActive: true),
        isSeen: false,
        publishedAt: DateTime.now());
  });
}
