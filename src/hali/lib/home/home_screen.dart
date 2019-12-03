import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/commons/bottom_loader.dart';
import 'package:hali/commons/dialog.dart';
import 'package:hali/config/application.dart';
import 'package:hali/config/routes.dart';
import 'package:hali/home/index.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:hali/commons/styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
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

  List<PostModel> _posts = [];

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  HomeBloc _homeBloc;
  int _currentPage = 0;
  bool _isReachMax = false;

@override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(Fetch(currentPage: _currentPage));
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
       listener: (context, state) {
        if(state is HomeUninitialized) {
          return LoadingIndicator(indicatorType: Indicator.ballPulse, color: Colors.red,);
        }
        if (state is HomeError) {
          return displayAlert(context, "Error", state.error.message);
        }

        if (state is HomeLoaded) {
            _isReachMax = state.hasReachedMax;
            _posts = state.posts;
        }
      },
      child: Scaffold(
        body: _posts.isEmpty ? EmptyPageContentScreen() : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= _posts.length
                  ? BottomLoader()
                  : FeedCard();
            },
            itemCount: _isReachMax
                ? _posts.length
                : _posts.length + 1,
            controller: _scrollController,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _presentCreatePostScreen,
            child: Icon(Icons.create,),
            backgroundColor: ColorUtils.hexToColor(colorD92c27),
          ),
      )
    );

  }

  _presentCreatePostScreen() {
    Application.router.navigateTo(context, Routes.createPost, transition: TransitionType.fadeIn);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (!_isReachMax) {
        _homeBloc.add(Fetch(currentPage: _currentPage + 1));
      }
    }
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

class EmptyPageContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Image.asset('assets/images/ic-empty.png'),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Không có dữ liệu nào'),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}

class _SliverEmptyPost extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
          height: 200,
          child: Card(
            margin: EdgeInsets.all(16),
            child: new Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Recruit places, become a ambassador!", style: Styles.getSemiboldStyle(16, Colors.black87),),
                ),
                EmptyPageContentScreen()
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
          margin: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
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

  final List<PostModel> posts;

  _ListPost(this.posts);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _renderPostItem(context, index),
        childCount: posts.length
        ),
    );
  }

  _renderPostItem(BuildContext context, int index) {
    return FeedCard(onTapCard: (){
      Application.router.navigateTo(context, Routes.feedDetail, transition: TransitionType.fadeIn);
    },);
  }

}
