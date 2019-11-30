import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/login/bloc/bloc.dart';
import 'package:hali/messages/message_list_screen.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/tests/test_list_screen.dart';
import 'package:hali/user_profile/user_profile_screen.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../home/home_screen.dart';

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

  void changePage(int index) {

    setState(() {
      _selectedIndex = index;
      controller.jumpToPage(index);
    });
  }

  void onPageViewChanged(int index) {
    setState(() {
      _selectedIndex = index;
      controller.jumpToPage(index);
    });
  }


  Widget _renderNotify() {
    return Container(
      padding: EdgeInsets.all(16),
      child: IconButton(icon: Icon(MdiIcons.bellRingOutline, color: Colors.black38,), onPressed: (){
        final repo = RepositoryProvider.of<UserRepository>(context);
        repo.signOut();
      },),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(fontSize: 20, color: ColorUtils.hexToColor(color1D1D1D)),),
          backgroundColor: Colors.white,
          actions: <Widget>[
            _renderNotify(),
          ],
        ),

        body: PageView(
          controller: controller,
          onPageChanged: onPageViewChanged,
          children: <Widget>[
            HomeScreen(name: "Home",),            
            UserProfileScreen(),
            MessageListScreen(),
            TestListScreen(),
          ],
          scrollDirection: Axis.horizontal,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.foodForkDrink),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.accountCircle),
              title: Text('Account'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.message),
              title: Text('Messages'),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.bottleTonic),
              title: Text('Tests'),
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
}