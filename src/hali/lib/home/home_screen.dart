import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_widgets/empty_page_content_screen.dart';
import 'package:hali/commons/bottom_loader.dart';
import 'package:hali/config/application.dart';
import 'package:hali/config/routes.dart';
import 'package:hali/home/index.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/utils/app_utils.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:hali/home/views/feed_card.dart';

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
  bool _isReachMax = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(HomeFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeUninitialized) {
            return LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              color: Colors.red,
            );
          }
          if (state is HomeError) {
            return dispatchFailure(context, state.error);
          }

          if (state is HomeLoaded) {
            _isReachMax = state.hasReachedMax;
            setState(() {
              _posts = state.posts;
            });
          }
        },
        child: Scaffold(
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeUninitialized) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return _buildHomeBody();
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endDocked,
          floatingActionButton: _buildFab(context),
        ));
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: _presentCreatePostScreen,
      child: Icon(
        Icons.create,
      ),
      backgroundColor: ColorUtils.hexToColor(colorD92c27),
    );
  }

  Widget _buildHomeBody() {
    return _posts.isEmpty
        ? EmptyPageContentScreen()
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return index >= _posts.length
                  ? BottomLoader()
                  : FeedCard(
                      onTapCard: () {
                        _navigateToDetailPost(_posts[index].id);
                      },
                      postModel: _posts[index],
                    );
            },
            itemCount: _isReachMax ? _posts.length : _posts.length + 1,
            controller: _scrollController,
          );
  }

  _presentCreatePostScreen() {
    Application.router.navigateTo(context, Routes.createPost,
        transition: TransitionType.fadeIn);
  }

  _navigateToDetailPost(String postId) {
    Application.router.navigateTo(
        context, Routes.feedDetail + "?postId=$postId",
        transition: TransitionType.fadeIn);
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
        _homeBloc.add(HomeFetchEvent());
      }
    }
  }
}
