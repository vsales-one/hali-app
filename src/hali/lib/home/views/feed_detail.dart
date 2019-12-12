import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/messages/request_listing_confirmation_screen.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/utils/app_utils.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:hali/home/views/feed_detail/index.dart';
import 'package:uuid/uuid.dart';

import '../home_screen.dart';

class FeedDetail extends StatefulWidget {
  final String postId;

  FeedDetail({this.postId});

  @override
  State<StatefulWidget> createState() {
    return FeedDetailScreenState();
  }
}

class FeedDetailScreenState extends State<FeedDetail> {

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

        if(state is RequestListingConfirmationState) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RequestListingConfirmationScreen(
              requestItem: state.message,
            )));
        }
      },

      child: Scaffold(
        body: (postModel == null) ? EmptyPageContentScreen() : Container(
          color: Colors.grey[200],
          child : CustomScrollView(
            slivers: <Widget>[
              // sliver app bar
              _VSliverAppBar(
                postModel: postModel,
              ),
              _LocationWidget(postModel: postModel,),
              _TitleWidget(postModel: postModel,),
              _DisplayLocation(lati: postModel.latitude, long: postModel.longitude,),
              _RequestButton(onSendItemRequest: () {
                _requestItem(context, postModel);
              }, distance: postModel.displayDistance(),)
            ],
          ),
        ),
      )
    );
  }

  _requestItem(BuildContext context, PostModel post) {
    // 1) open request listing confirmation screen
    // 2) on confirmed at confirmation screen send a message from requestor to owner
    // 3) Then goes to message screen
    _bloc.add(RequestListingConfirmationEvent(post: post));    
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
          background: (postModel.imageUrl == null || isDirtyImage()) ? Image.asset("assets/images/placeholder.kpg")  : Image.network(
            postModel.imageUrl ?? "",
            fit: BoxFit.cover,
          )),
    );
  }

  bool isDirtyImage() {
    return !this.postModel.imageUrl.contains("https");
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
                              "Pickup Time: " + postModel.pickupTimeDisplay(),
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
  final double distance;  
  final VoidCallback onSendItemRequest;

  _RequestButton({this.onSendItemRequest, this.distance});

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
              onPressed: onSendItemRequest
            ),
          ],
        ),
      ),
    );
  }  
}


class _DisplayLocation extends StatelessWidget {

  final double lati;
  final double long;
  final String userName;

  GoogleMapController mapController;

  final Set<Marker> _markers = {};

  _DisplayLocation({ this.lati, this.long, this.userName});

  void _onAddMarkerButtonPressed() {
    _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(Uuid().v4()),
        position: new LatLng(lati, long),
        infoWindow: InfoWindow(
          title: userName,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
  }

  @override
  Widget build(BuildContext context) {

    _onAddMarkerButtonPressed();

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300,
        child: Container(
          margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
          child: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: _markers,
            initialCameraPosition: new CameraPosition(target: LatLng(lati, long),
          ),
        ),
        )
      ),
    );
  }

}