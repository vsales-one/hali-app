import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/login/login.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng Nhập')),
      body: BlocProvider<LoginBloc>(
        builder: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}
