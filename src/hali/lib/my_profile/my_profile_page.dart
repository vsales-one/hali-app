import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/my_profile/index.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyProfile'),
      ),
      body: MyProfileScreen(myProfileBloc: BlocProvider.of<MyProfileBloc>(context)),
    );
  }
}
