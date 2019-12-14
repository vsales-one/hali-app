import 'package:flutter/material.dart';
import 'package:hali/user_profile/my_public_profile_screen.dart';

class MyPublicProfilePage extends StatelessWidget {
  const MyPublicProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyPublicProfileScreen(),
    );
  }
}
