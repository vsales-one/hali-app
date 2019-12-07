import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/my_profile/index.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({
    Key key,
    @required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(key: key);

  final UserRepository _userRepository;

  @override
  MyProfileScreenState createState() {
    return MyProfileScreenState(_userRepository);
  }
}

class MyProfileScreenState extends State<MyProfileScreen> {
  final UserRepository _userRepository;

  MyProfileScreenState(this._userRepository);

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

    return BlocBuilder<MyProfileBloc, MyProfileState>(builder: (
      BuildContext context,
      MyProfileState currentState,
    ) {
      return new Container(
        height: headerHeight,
        decoration: new BoxDecoration(
          color: ColorUtils.hexToColor(colorD92c27),
          boxShadow: <BoxShadow>[
            new BoxShadow(
                spreadRadius: 2.0,
                blurRadius: 4.0,
                offset: new Offset(0.0, 1.0),
                color: Colors.black38),
          ],
        ),
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // linear gradient
            new Container(
              height: headerHeight,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: <Color>[
                  //7928D1
                  const Color(0xFF7928D1), const Color(0xFF9A4DFF)
                ], stops: <double>[
                  0.3,
                  0.5
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
              ),
            ),
            // radial gradient
            new CustomPaint(
              painter: new HeaderGradientPainter(),
            ),
            new Padding(
              padding: new EdgeInsets.only(
                  top: topPadding, left: 15.0, right: 15.0, bottom: 20.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildBellIcon(),
                  new Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: _buildTitle(),
                  ),
                  new Padding(
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
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new IconButton(
            icon: new Icon(
              MdiIcons.bell,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {}),
      ],
    );
  }

  Widget _buildTitle() {
    return new Text("Profile",
        style: Styles.getSemiboldStyle(40, Colors.white));
  }

  /// The avatar consists of the profile image, the users name and location
  Widget _buildAvatar() {
    return new Row(
      children: <Widget>[
        new Container(
          width: 70.0,
          height: 60.0,
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("assets/images/ic-avatar.png"),
                fit: BoxFit.cover),
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                  color: Colors.black26, blurRadius: 5.0, spreadRadius: 1.0),
            ],
          ),
        ),
        new Padding(padding: const EdgeInsets.only(right: 20.0)),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Trung Vu",
                style: Styles.getSemiboldStyle(16, Colors.white)),
            new Text("91 Ng", style: Styles.getRegularStyle(16, Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildFollowerStats() {
    return new Row(
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
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(title, style: Styles.getSemiboldStyle(16, Colors.white)),
        new Text(value, style: Styles.getRegularStyle(16, Colors.white)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return new Container(
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
