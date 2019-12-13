import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/home/home_event.dart';
import 'package:hali/models/post_model.dart';
import 'package:hali/posts/post_widgets/photo_cover.dart';
import 'package:hali/posts/post_widgets/post_form.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/utils/app_utils.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'bloc/index.dart';

class CreatePostScreen extends StatefulWidget {
  final AbstractPostRepository _postRepository;

  const CreatePostScreen(
      {Key key, @required AbstractPostRepository postRepository})
      : assert(postRepository != null),
        _postRepository = postRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreatePostScreenState();
  }
}

class CreatePostScreenState extends State<CreatePostScreen> {
  AbstractPostRepository get postRepository => widget._postRepository;
  CreatePostBloc _createPostBloc;
  File _image;
  String _postImageUrl;
  PostModel postModel = PostModel();

  _handleOpenCamera() {
    getImage();
  }

  _handleOpenGallery() {
    getGallery();
  }

  Future getImage() async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    _createPostBloc
        .add(UploadPostImageEvent(image: image, postModel: postModel));

    setState(() {
      _image = image;
    });
  }

  Future getGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );
    _createPostBloc
        .add(UploadPostImageEvent(image: image, postModel: postModel));
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
                PhotoCover(
                  openCamera: _handleOpenCamera,
                  image: _image,
                  openGallery: _handleOpenGallery,
                ),
                PostForm(
                  image: _image,
                  postImageUrl: _postImageUrl,
                )
              ],
            ),
          ),
        ),
      ),
    );
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state.error != null) {
          dispatchFailure(context, state.error);
        } else if (state.postModel != null && state.isPostCreatedSuccess) {
          _createPostBloc.homeBloc.add(HomeFetchEvent(categoryId: state.postModel.categoryId));
          Navigator.of(context).pop();
        } else if (state.postModel != null &&
            state.isPostImageUploadedSuccess &&
            state.postModel.imageUrl != null &&
            state.postModel.imageUrl.isNotEmpty) {
          _postImageUrl = state.postModel.imageUrl;
          logger.d(">>>>>>>: post image uploaded url: $_postImageUrl");
        }
      },
      child: BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) {
          return ModalProgressHUD(
            child: screen,
            inAsyncCall: state.isLoading,
          );
        },
      ),
    );
  }
}
