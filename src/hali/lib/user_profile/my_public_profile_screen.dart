import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/user_profile/bloc/user_profile_bloc.dart';
import 'package:hali/user_profile/bloc/user_profile_state.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyPublicProfileScreen extends StatefulWidget {
  const MyPublicProfileScreen({
    Key key,
    @required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(key: key);

  final UserRepository _userRepository;

  @override
  MyPublicProfileScreenState createState() =>
      MyPublicProfileScreenState(_userRepository);
}

class MyPublicProfileScreenState extends State<MyPublicProfileScreen> {
  final UserRepository _userRepository;

  MyPublicProfileScreenState(this._userRepository);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final headerGradient = new RadialGradient(
      center: Alignment.topLeft,
      radius: 0.4,
      colors: <Color>[
        const Color(0xFF8860EB),
        const Color(0xFF8881EB),
      ],
      stops: <double>[
        0.4,
        1.0,
      ],
      tileMode: TileMode.repeated,
    );

    const headerHeight = 290.0;

    return BlocBuilder<UserProfileBloc, UserProfileState>(builder: (
      BuildContext context,
      UserProfileState currentState,
    ) {
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
                gradient: LinearGradient(colors: <Color>[
                  //7928D1
                  const Color(0xFF7928D1), const Color(0xFF9A4DFF)
                ], stops: <double>[
                  0.3,
                  0.5
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
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
                  _buildBellIcon(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _buildTitle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _buildAvatar(),
                  ),
                  _buildFollowerStats()
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Build the bell icon at the top right corner of the header
  Widget _buildBellIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
            icon: Icon(
              MdiIcons.bell,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {}),
      ],
    );
  }

  Widget _buildTitle() {
    return Text("Profile", style: Styles.getSemiboldStyle(40, Colors.white));
  }

  /// The avatar consists of the profile image, the users name and location
  Widget _buildAvatar() {
    return Row(
      children: <Widget>[
        Container(
          width: 70.0,
          height: 60.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/ic-avatar.png"),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26, blurRadius: 5.0, spreadRadius: 1.0),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.only(right: 20.0)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Trung Vu", style: Styles.getSemiboldStyle(16, Colors.white)),
            Text("91 Ng", style: Styles.getRegularStyle(16, Colors.white)),
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
        _buildFollowerStat("Followers", "1012"),
        _buildVerticalDivider(),
        _buildFollowerStat("Following", "1232312"),
        _buildVerticalDivider(),
        _buildFollowerStat("Total Likes", "23212"),
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
}

class HeaderGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: paint background radial gradient
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
