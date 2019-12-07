import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/my_profile/index.dart';
import 'package:hali/repositories/user_repository.dart';

class MyProfilePage extends StatelessWidget {

  final UserRepository _userRepository;

  const MyProfilePage({Key key, UserRepository userRepository}) : assert(userRepository != null), _userRepository = userRepository, super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyProfileBloc>(
        builder: (context) => new MyProfileBloc(),
        child:  Scaffold(
          body: MyProfileScreen(userRepository: _userRepository,),
        ),
    );
  }
}
