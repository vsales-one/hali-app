import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/home/home_screen.dart';
import 'package:hali/home/views/feed_detail/widgets/index.dart';
import 'package:hali/messages/request_listing_confirmation_screen.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/utils/app_utils.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:hali/home/views/feed_detail/index.dart';

class FeedDetailScreen extends StatefulWidget {
  final String postId;

  FeedDetailScreen({this.postId});

  @override
  State<StatefulWidget> createState() {
    return FeedDetailScreenState();
  }
}

class FeedDetailScreenState extends State<FeedDetailScreen> {
  PostModel postModel;
  FeedDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FeedDetailBloc>(context);
    _bloc.add(FeedEventFetch(postId: widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedDetailBloc, FeedDetailState>(
        listener: (context, state) {
          if (state is FeedDetailUninitialized) {
            return LoadingIndicator(
              indicatorType: Indicator.pacman,
              color: Colors.red,
            );
          }

          if (state is FeedDetailError) {
            return dispatchFailure(context, state.error);
          }

          if (state is FeedDetailLoaded) {
            setState(() {
              postModel = state.postModel;
            });
          }

          if (state is RequestListingConfirmationState) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequestListingConfirmationScreen(
                      requestItem: state.message,
                    )));
          }
        },
        child: Scaffold(
          body: (postModel == null)
              ? EmptyPageContentScreen()
              : Container(
                  color: Colors.grey[200],
                  child: CustomScrollView(
                    slivers: <Widget>[
                      // sliver app bar
                      FeedDetailSliverAppBar(
                        postModel: postModel,
                      ),
                      FeedDetailLocationWidget(
                        postModel: postModel,
                      ),
                      FeedDetailTitleWidget(
                        postModel: postModel,
                      ),
                      FeedDetailDisplayLocation(
                        lati: postModel.latitude,
                        long: postModel.longitude,
                      ),
                      FeedDetailRequestButton(
                        onSendItemRequest: () {
                          _requestItem(context, postModel);
                        },
                        distance: postModel.displayDistance(),
                      )
                    ],
                  ),
                ),
        ));
  }

  _requestItem(BuildContext context, PostModel post) {
    // 1) open request listing confirmation screen
    // 2) on confirmed at confirmation screen send a message from requestor to owner
    // 3) Then goes to message screen
    _bloc.add(RequestListingConfirmationEvent(post: post));
  }
}
