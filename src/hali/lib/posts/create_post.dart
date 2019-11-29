import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/commons/styles.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'bloc/index.dart';
import 'create_food_form.dart';

class CreatePostScreen extends StatefulWidget {
  final PostRepository _postRepository;

  const CreatePostScreen({Key key,@required PostRepository postRepository}) 
  : assert(postRepository != null),
    _postRepository = postRepository,
   super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreatePostScreenState();
  }
}

class CreatePostScreenState extends State<CreatePostScreen> {

  CreatePostBloc _createPostBloc;

  PostRepository get postRepository => widget._postRepository;

  File _image;

  _handleOpenCamera() {
    getImage();
  }

  _handleOpenGallery() {
    getGallery();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
    _createPostBloc = BlocProvider.of<CreatePostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = Scaffold(
      appBar: AppBar(
        backgroundColor: ColorUtils.hexToColor(colorD92c27),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: Colors.grey[200],
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Container(
            color: Colors.white,
            child: CustomScrollView(
              slivers: <Widget>[
                _PhotoCover(
                  openCamera: _handleOpenCamera,
                  image: _image,
                  openGallery: _handleOpenGallery,
                ),
                _ContentForm()
              ],
            ),
          ),
        ),
      ),
    );
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) => {},
      child: BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) {
          return screen;
        },
      ),
    );
  }
}

class _PhotoCover extends StatelessWidget {
  Function openCamera;

  File image;

  Function openGallery;

  _PhotoCover({this.openCamera, this.image, this.openGallery});

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
                image == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 80,
                        color: Colors.grey,
                      )
                    : new Container(),
                Container(
                  width: 150,
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: ColorUtils.hexToColor(colorD92c27),
                      borderRadius: BorderRadius.circular(15)),
                  child: FlatButton(
                      onPressed: openCamera,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                          Text(
                            "Take a Photo",
                            style: Styles.getRegularStyle(14, Colors.white),
                          )
                        ],
                      )),
                ),
                _UploadFromGallery(
                  openGallery: openGallery,
                  image: image,
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              image: DecorationImage(
                  image: image == null
                      ? AssetImage("assets/images/placeholder.jpg")
                      : new FileImage(image),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}

class _UploadFromGallery extends StatelessWidget {
  VoidCallback openGallery;
  File image;
  _UploadFromGallery({this.openGallery, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: FlatButton(
          onPressed: openGallery,
          child: Text(
            "Upload from gallery",
            style: image == null
                ? Styles.getRegularStyle(14, Colors.blueGrey)
                : Styles.getRegularStyle(14, Colors.white),
          )),
    );
  }
}

class _ContentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 700,
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

class _TabbarContentState extends State<_TabBarContent>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget getTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(text: "Food", icon: Icon(MdiIcons.food)),
        Tab(text: "Non-Food", icon: Icon(MdiIcons.ceilingLight)),
      ],
      unselectedLabelColor: Colors.grey,
      indicatorColor: ColorUtils.hexToColor(colorD92c27),
      labelColor: ColorUtils.hexToColor(colorD92c27),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: getTabBar(),
        ),
        leading: new Container(),
        backgroundColor: Colors.white,
      ),
      body: TabBarView(
        children: [
          CreateFoodForm(),
          CreateFoodForm(),
        ],
        controller: _tabController,
      ),
    );
  }
}
