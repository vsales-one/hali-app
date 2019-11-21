import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/authentication_bloc/bloc.dart';
import 'package:hali/commons/color_utils.dart';
import 'package:hali/commons/styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'views/feed_card.dart';
class HomeScreen extends StatefulWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {

  bool isHiddenBannerInvite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _SliverCategory(),
          _SliverCreateAmbasador(),
          isHiddenBannerInvite ? _SliverEmpty() : _InvitationBanner(closeInvitationBanner: _closeInvitationHandle,),
          _ListPost()
        ],
      ),
    );
  }

  _closeInvitationHandle() {
    setState(() {
      isHiddenBannerInvite = !isHiddenBannerInvite;
    });
  }

}

class _SliverEmpty extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
            height: 10,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white
                ),
            )
        )
    );
  }

}

class _SliverCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(icon: Icon(MdiIcons.filterMenuOutline), onPressed: null),
                  IconButton(icon: Icon(Icons.dashboard),)
                ],
              )
            )
        )
    );
  }
}

class _SliverCreateAmbasador extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
          height: 190,
          child: Card(
            margin: EdgeInsets.all(16),
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Recruit places, become a ambassador!", style: Styles.getSemiboldStyle(16, Colors.black87),),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Text("As a ambassador, you not only save your foods, but also help people", style: Styles.getRegularStyle(14, Colors.black54), textAlign: TextAlign.center,)
                ),
                
                Container(
                  height: 35,
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: FlatButton(
                      child: Text("Create your store", textAlign: TextAlign.center, style: Styles.getRegularStyle(14, Colors.white),),
                    ),
                  decoration: BoxDecoration(
                    color: ColorUtils.hexToColor(colorD92c27),
                    borderRadius: BorderRadius.circular(15)
                  ),
                    
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          )
      ),
    );
  }
}

class _InvitationBanner extends StatelessWidget {

  VoidCallback closeInvitationBanner;

  _InvitationBanner({this.closeInvitationBanner});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 190,
        child: Card(
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Make it great together!", style: Styles.getSemiboldStyle(16, Colors.white),),
                    ),
                    IconButton(icon: Icon(Icons.close, color: Colors.white,), color: Colors.white, onPressed: closeInvitationBanner,),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 35,
                          child: FlatButton(
                              onPressed: null,
                              child: Text("Invite your friends", style: Styles.getSemiboldStyle(16, Colors.black54))),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)
                          ),
                        ),
                      ],
                    ),

                  )
                )
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/invitation.png",), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(8)
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

class _ListPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) => _renderPostItem(context, index)),
    );
  }

  _renderPostItem(BuildContext context, int index) {
    return FeedCard();
  }
}
