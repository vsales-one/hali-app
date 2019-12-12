import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/constants/constants.dart';
import 'package:hali/home/index.dart';
import 'package:hali/messages/message_list_screen.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/user_profile/my_public_profile_page.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController controller = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  void onPageViewChanged(int index) {
    setState(() {
      _selectedIndex = index;
      if (index < 3) {
        controller.jumpToPage(index);
      } else {
        _showAppInfo();
      }
    });
  }

  Widget _renderNotify() {
    return Container(
      padding: EdgeInsets.all(16),
      child: IconButton(
        icon: Icon(
          MdiIcons.bellRingOutline,
          color: Colors.black38,
        ),
        onPressed: () {
          final repo = RepositoryProvider.of<UserRepository>(context);
          repo.signOut();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: 20, color: ColorUtils.hexToColor(color1D1D1D)),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          _renderNotify(),
        ],
      ),
      body: PageView(
        controller: controller,
        onPageChanged: onPageViewChanged,
        children: <Widget>[
          HomePage(
            userRepository: RepositoryProvider.of<UserRepository>(context),
            homeRepository: RepositoryProvider.of<HomeRepository>(context),
          ),
          MessageListScreen(),
          MyPublicProfilePage(userRepository: RepositoryProvider.of<UserRepository>(context),),
          // UserProfileScreen(),
        ],
        scrollDirection: Axis.horizontal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.foodForkDrink),
            title: Text('Hali'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.message),
            title: Text('Tin Nhắn'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.accountCircle),
            title: Text('Người Dùng'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.information),
            title: Text('Thông Tin'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: ColorUtils.hexToColor(colorD92c27),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: onPageViewChanged,
      ),
    );
  }

  void _showAppInfo() {
    showAboutDialog(
      context: context,
      applicationName: "Hali",
      applicationVersion: kAppVersion,
      applicationLegalese: "© 2019 The Hali Team",
      applicationIcon: Image.asset('assets/images/hali_logo_199.png', width: 64, height: 64,),
    );
  }
}
