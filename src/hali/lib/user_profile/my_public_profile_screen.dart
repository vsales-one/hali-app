import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_widgets/generic_error_screen.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/user_profile/bloc/bloc.dart';
import 'package:hali/user_profile/bloc/user_profile_bloc.dart';
import 'package:hali/user_profile/bloc/user_profile_state.dart';
import 'package:hali/user_profile/user_profile_screen.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:image_picker/image_picker.dart';

class MyPublicProfileScreen extends StatefulWidget {
  @override
  _MyPublicProfileScreenState createState() => _MyPublicProfileScreenState();
}

class _MyPublicProfileScreenState extends State<MyPublicProfileScreen> {
  UserProfile model;
  UserProfileBloc _userProfileBloc;  

  @override
  void initState() {
    super.initState();
    _userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    _userProfileBloc..add(UserProfileLoading());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildLoadingBody() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(builder: (
      BuildContext context,
      UserProfileState currentState,
    ) {
      if (currentState is UserProfileLoadingState) {
        return _buildLoadingBody();
      }
      if (currentState is UserProfileLoadedState) {
        this.model = currentState.userProfile;        
        return _buildBody();
      }
      if(currentState is UserProfileNotUpdatedState) {
        return GenericErrorScreen();
      }
    });
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        _buildProfileCard(),
        Container(
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            color: Colors.blueAccent,
            child: Text(
              "Cập Nhật Thông Tin Cá Nhân",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => UserProfileScreen()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    final topPadding = MediaQuery.of(context).padding.top;
    const headerHeight = 290.0;
    return Container(
      height: headerHeight,
      decoration: BoxDecoration(
        color: ColorUtils.hexToColor(colorD92c27),
        boxShadow: <BoxShadow>[
          BoxShadow(
            spreadRadius: 2.0,
            blurRadius: 4.0,
            offset: Offset(0.0, 1.0),
            color: Colors.black38,
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // linear gradient
          Container(
            height: headerHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  ColorUtils.hexToColor(colorF0857A),
                  ColorUtils.hexToColor(colorD92c27),
                  // const Color(0xFF7928D1),
                  // const Color(0xFF9A4DFF)
                ],
                stops: <double>[0.3, 0.5],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          // radial gradient
          CustomPaint(
            painter: HeaderGradientPainter(),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: topPadding, left: 15.0, right: 15.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: _buildTitle(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _buildAvatar(),
                ),
                _buildFollowerStats(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "",
      style: Styles.getSemiboldStyle(40, Colors.white),
    );
  }

  /// The avatar consists of the profile image, the users name and location
  Widget _buildAvatar() {
    final userImage = model.imageUrl.isNotEmpty
        ? NetworkImage(model.imageUrl,)
        : AssetImage("assets/images/ic-avatar.png");
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: userImage,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
          ),
          onTap: () {
            _openGallery();
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              model.displayName ?? model.email,
              style: Styles.getSemiboldStyle(16, Colors.white),
            ),
            Text(
              model.address,
              style: Styles.getRegularStyle(16, Colors.white),
            ),
            Text(
              model.district,
              style: Styles.getRegularStyle(16, Colors.white),
            ),
            Text(
              model.city,
              style: Styles.getRegularStyle(16, Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFollowerStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _buildFollowerStat("Quan tâm", "0"),
        _buildVerticalDivider(),
        _buildFollowerStat("Theo dõi", "0"),
        _buildVerticalDivider(),
        _buildFollowerStat("Đánh giá", "0"),
      ],
    );
  }

  Widget _buildFollowerStat(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(title, style: Styles.getSemiboldStyle(16, Colors.white)),
        Text(value, style: Styles.getRegularStyle(16, Colors.white)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30.0,
      width: 1.0,
      color: Colors.white30,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }

  Future _openGallery() async {
    logger.d(">>>>>>> open gallery to change avatar");
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    _userProfileBloc.add(UpdateUserAvatarImageUrlEvent(userProfile: model, newUserImage: image));
  }
}

class HeaderGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
