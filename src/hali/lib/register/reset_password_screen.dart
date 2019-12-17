import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/register/reset_password_form.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/register/register.dart';

class ResetPasswordScreen extends StatelessWidget {
  final UserRepository _userRepository;

  ResetPasswordScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quên mật khẩu')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          builder: (context) => RegisterBloc(userRepository: _userRepository),
          child: ResetPasswordForm(),
        ),
      ),
    );
  }
}
