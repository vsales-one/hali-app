import 'package:flutter/material.dart';
import 'package:hali/constants/constants.dart';
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
      child: Icon(MdiIcons.bellRingOutline, color: Colors.black38,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(fontSize: 20, color: hexToColor(black1D1D1D)),),
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
            Container(
              child: Center(child:Text("Page 2")),
              color: Colors.blueAccent,
            ),

            Container(
              child: Center(child:Text("Page 3")),
              color: Colors.green,
            ),
            Container(
              child: Center(child:Text("Page 3")),
              color: Colors.green,
            )
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
              icon: Icon(Icons.home),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.heart),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.accountCircle),
              title: Text(''),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: hexToColor(redPrimary),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: onPageViewChanged,
        ),
    );
  }
}