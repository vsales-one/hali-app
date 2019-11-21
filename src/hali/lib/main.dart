import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/authentication_bloc/bloc.dart';
import 'package:hali/config/application.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/home/home_screen.dart';
import 'package:hali/login/login.dart';
import 'package:hali/splash_screen.dart';
import 'package:hali/simple_bloc_delegate.dart';

import 'main/main_tab_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      builder: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is Authenticated) {
            return MainScreen(title: "",);
          }
          return SplashScreen();
        },
      ),
      onGenerateRoute: Application.router.generator,
    );
  }
}
