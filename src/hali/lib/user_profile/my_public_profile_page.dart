import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/user_profile/bloc/user_profile_bloc.dart';
import 'package:hali/user_profile/my_public_profile_screen.dart';

class MyPublicProfilePage extends StatelessWidget {
  final UserRepository _userRepository;

  const MyPublicProfilePage({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserProfileBloc>(
      builder: (context) => BlocProvider.of<UserProfileBloc>(context),
      child: Scaffold(
        body: MyPublicProfileScreen(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
