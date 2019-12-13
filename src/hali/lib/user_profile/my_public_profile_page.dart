import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hali/user_profile/bloc/user_profile_bloc.dart';
import 'package:hali/user_profile/my_public_profile_screen.dart';

class MyPublicProfilePage extends StatelessWidget {
  const MyPublicProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyPublicProfileScreen(),
    );
    // return BlocProvider<UserProfileBloc>(
    //   builder: (context) => BlocProvider.of<UserProfileBloc>(context),
    //   child: Scaffold(
    //     body: MyPublicProfileScreen(),
    //   ),
    // );
  }
}
