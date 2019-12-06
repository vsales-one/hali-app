import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/messages/request_listing_confirmation_screen.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:uuid/uuid.dart';
import 'package:hali/home/views/feed_detail/index.dart';

class FeedDetail extends StatefulWidget {
  final int postId;

  FeedDetail({this.postId});

  @override
  State<StatefulWidget> createState() {
    return FeedDetailScreenState();
  }
}

class FeedDetailScreenState extends State<FeedDetail> {
  PostModel postModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedDetailBloc, FeedDetailState>(
      listener: (context, state) {
        if (state is FeedDetailUninitialized) {
           LoadingIndicator(
            indicatorType: Indicator.pacman,
            color: Colors.red,
          );
        }
        if (state is FeedDetailLoaded) {
          postModel = state.postModel;
        }
      },
      child: postModel != null ? Container(
        color: Colors.grey[200],
        child: CustomScrollView(
          slivers: <Widget>[
            // sliver app bar
            _VSliverAppBar(
              postModel: postModel,
            ),
            _LocationWidget(),
            _TitleWidget(),
            _RequestButton()
          ],
        ),
      ) :  new Container(),
    );
  }
}

class _VSliverAppBar extends StatelessWidget {
  final PostModel postModel;

  _VSliverAppBar({this.postModel});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text("",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              )),
          background: Image.network(
            postModel.imageUrl ?? "",
            fit: BoxFit.cover,
          )),
    );
  }
}

class _TitleWidget extends StatelessWidget {

  final PostModel postModel;

  _TitleWidget({this.postModel});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Container(
              padding: EdgeInsets.only(left: 16, top: 20, bottom: 20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      postModel.title ?? "",
                      style: Styles.getSemiboldStyle(25, Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    postModel.description ?? "",
                    style: Styles.getRegularStyle(16, Colors.black54),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ))
      ]),
    );
  }
}

class _LocationWidget extends StatelessWidget {

  final PostModel postModel;

  _LocationWidget({ this.postModel });

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
                          Padding(
                            child: Icon(
                              Icons.date_range,
                              color: Colors.black54,
                            ),
                            padding: EdgeInsets.only(right: 16),
                          ),
                          Expanded(
                            child: Text(
                              "Pickup Time: " + postModel.pickUpTime,
                              style:
                                  Styles.getSemiboldStyle(14, Colors.black54),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.black54,
                            ),
                            padding: EdgeInsets.only(right: 16),
                          ),
                          Expanded(
                            child: Text(
                              postModel.pickupAddress ?? "",
                              style:
                                  Styles.getSemiboldStyle(14, Colors.black54),
                            ),
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
                        child: Padding(
                          child: Icon(
                            Icons.share,
                            color: Colors.black54,
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                      ),
                      Container(
                        child: Padding(
                          child: Icon(
                            Icons.favorite_border,
                            color: Colors.black54,
                          ),
                          padding: EdgeInsets.all(8),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                )
              ],
            )),
      ],
    ));
  }
}

class _RequestButton extends StatelessWidget {

  final int distance;

  _RequestButton({this.distance});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ColorUtils.hexToColor(colorD92c27),
            borderRadius: BorderRadius.circular(24)),
        child: Column(
          children: <Widget>[
            FlatButton(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Request listing",
                      style: Styles.getRegularStyle(14, Colors.white),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.white,
                          ),
                          Text(
                            "$distance km away",
                            style: Styles.getRegularStyle(14, Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                onPressed: () {
                  _requestItem(context, itemListing[Random().nextInt(10)]);
                }),
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
            imageUrl: "https://api.adorable.io/avatars/100/abott@adorable.png",
            userId: "y41Rrmr7A0gzniC9kSudv6RmeA62",
            email: "brtometh@gmail.com",
            isActive: true),
        isSeen: false,
        publishedAt: DateTime.now());
  });
}
