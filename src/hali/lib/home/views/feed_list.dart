import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hali/config/application.dart';
import 'package:hali/config/routes.dart';
import 'feed_card.dart';
class FeedList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FeedListState();
  }

}

class FeedListState extends State<FeedList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) => _buildFeedCard(context, index),
        itemCount: 10,
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
      )
    );
  }

  _buildFeedCard(BuildContext context, int index) {
    return FeedCard(onTapCard: _onTapCard,);
  }

  _onTapCard() {
    Application.router.navigateTo(context, Routes.feedDetail, transition: TransitionType.fadeIn);
  }

}