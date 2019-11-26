
import 'package:flutter/material.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'create_food_form.dart';
class CreatePostScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return CreatePostScreenState();
  }
}
class CreatePostScreenState extends State<CreatePostScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.hexToColor(colorD92c27),
      ),
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            _PhotoCover(),
            _ContentForm()
          ],
        ),
      ),
    );
  }
}

class _PhotoCover extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return SliverToBoxAdapter(
       child: SizedBox(
         height: 300,
         child: Container(
           child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 Icon(Icons.camera_alt, size: 80, color: Colors.grey,),
                 _TakePhoto(),
                 _UploadFromGallery(),
               ],
             ),
           ),
           decoration: BoxDecoration(
             color: Colors.grey[300]
           ),
         ),
       ),
     );
  }
}

class _TakePhoto extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorUtils.hexToColor(colorD92c27),
        borderRadius: BorderRadius.circular(15)
      ),
      child: FlatButton(
          onPressed: null,
          child: Text("Take a Photo", style: Styles.getRegularStyle(14, Colors.white),)
      ),
    );
  }
}

class _UploadFromGallery extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15)
      ),
      child: FlatButton(
          onPressed: null,
          child: Text("Upload from gallery", style: Styles.getRegularStyle(14, Colors.blueGrey),)
      ),
    );
  }
}

class _ContentForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 800,
        child: _TabBarContent(),
      ),
    );
  }
}

class _TabBarContent extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _TabbarContentState();
  }
}

class _TabbarContentState extends State<_TabBarContent> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget getTabBar() {
    return TabBar(controller: _tabController, tabs: [
      Tab(text: "Add", icon: Icon(MdiIcons.food)),
      Tab(text: "Edit", icon: Icon(MdiIcons.ceilingLight)),
    ]);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: getTabBar(),
        ),
        leading: new Container(),
      ),
      body: TabBarView(
        children: [
          CreateFoodForm(),
          new Text("This is chat Tab View"),
        ],
        controller: _tabController,),
    );
  }
}