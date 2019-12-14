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
  String _screenTitle = "Thực Phẩm";
  int _categoryId = 1;
  static const Map<int, String> ScreenTitle = {
    0: "Thực Phẩm & Đồ Dùng",    
    1: "Tin Nhắn",
    2: "Người Dùng",
    3: "Thông Tin"
  };

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;    
  }

  @override
  void dispose() {        
    controller.dispose();
    super.dispose();
  }

  void onPageViewChanged(int index) {
    print(">>>>>>> onPageViewChanged: $index");
    setState(() {
      _screenTitle = ScreenTitle[index];
      _selectedIndex = index;
      if(index <= 1) {
        // food category = 1, non-food = 2
        _categoryId = index + 1;
      }      
      if (index == 3) {
        _showAppInfo();
      } else {
        // controller.jumpToPage(index);
        controller.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  Widget _renderNotify() {
    return Container(
      padding: EdgeInsets.all(16),
      child: IconButton(
        icon: Icon(
          MdiIcons.bellRingOutline,
          color: Colors.white,
        ),
        onPressed: () {
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _screenTitle,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorUtils.hexToColor(colorD92c27),
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
            categoryId: _categoryId,
            title: _screenTitle,
          ),
          MessageListScreen(),
          MyPublicProfilePage(),
        ],
        scrollDirection: Axis.horizontal,
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(      
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.foodForkDrink),
          title: Text("Thực Phẩm & Đồ Dùng Khác"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.message),
          title: Text("Tin Nhắn"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.accountCircle),
          title: Text("Người Dùng"),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.information),
          title: Text("Thông Tin"),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: ColorUtils.hexToColor(colorD92c27),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onPageViewChanged,
    );
  }

  void _showAppInfo() {
    showAboutDialog(
      context: context,
      applicationName: "Hali",
      applicationVersion: kAppVersion,
      applicationLegalese: "© 2019 The Hali Team",
      applicationIcon: Image.asset(
        'assets/images/hali_logo_199.png',
        width: 64,
        height: 64,
      ),
    );
  }
}
