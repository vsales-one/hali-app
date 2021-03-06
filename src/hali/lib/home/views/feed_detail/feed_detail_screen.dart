import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_widgets/empty_page_content_screen.dart';
import 'package:hali/config/application.dart';
import 'package:hali/home/views/feed_detail/widgets/index.dart';
import 'package:hali/messages/request_listing_confirmation_screen.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/utils/alert_helper.dart';
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
  bool isPostOwnedByCurrentUser;

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
            isPostOwnedByCurrentUser =
                postModel.lastModifiedBy == Application.currentUser.email;
          });
        }

        if (state is RequestListingConfirmationState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RequestListingConfirmationScreen(
                requestItem: state.message,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<FeedDetailBloc, FeedDetailState>(
        builder: (context, state) {
      if (state is FeedDetailUninitialized) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return _buildBodyConent();
    });
  }

  Widget _buildBodyConent() {
    return (postModel == null)
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
                  latitude: postModel.latitude,
                  longitude: postModel.longitude,
                ),
                FeedDetailRequestButton(
                  onSendItemRequest: () {
                    _requestItem(context, postModel);
                  },
                  distance: postModel.displayDistance(),
                ),
              ],
            ),
          );
  }

  _requestItem(BuildContext context, PostModel post) {
    // 1) open request listing confirmation screen
    // 2) on confirmed at confirmation screen send a message from requestor to owner
    // 3) Then goes to message screen
    if (isPostOwnedByCurrentUser) {
      AlertHelper.showAlertInfo(
          context, "Không thể yêu cầu nhận món đồ của chính bạn.");
      return;
    }
    _bloc.add(
        RequestListingConfirmationEvent(postId: widget.postId, post: post));
  }
}
