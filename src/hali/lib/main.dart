import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_theme.dart';
import 'package:hali/app_widgets/generic_loading_screen.dart';
import 'package:hali/authentication_bloc/bloc.dart';
import 'package:hali/config/application.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/home/index.dart';
import 'package:hali/repositories/chat_message_repository.dart';
import 'package:hali/repositories/post_repository.dart';
import 'package:hali/repositories/post_repository_factory.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/login/login.dart';
import 'package:hali/splash_screen.dart';
import 'package:hali/simple_bloc_delegate.dart';
import 'package:hali/main/main_tab_screen.dart';
import 'package:hali/user_profile/bloc/user_profile_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepo = UserRepository();
  final postRepo = PostRepositoryFactory.instance();

  runApp(
    MultiRepositoryProvider(providers: [
      RepositoryProvider<UserRepository>(
        builder: (_) => userRepo,
      ),
      RepositoryProvider<ChatMessageRepository>(
        builder: (_) => ChatMessageRepository(
            userRepository: userRepo, fireStore: Firestore.instance),
      ),
      RepositoryProvider<HomeRepository>(
        builder: (_) => HomeRepository(postRepository: postRepo),
      ),
      RepositoryProvider<AbstractPostRepository>(
        builder: (_) => postRepo,
      )
    ], child: App()),
  );
}

class App extends StatelessWidget {
  App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userRepo = RepositoryProvider.of<UserRepository>(context);
    assert(userRepo != null);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          builder: (_) =>
              AuthenticationBloc(userRepository: userRepo)..add(AppStarted()),
        ),
        BlocProvider<UserProfileBloc>(
          builder: (_) => UserProfileBloc(userRepository: userRepo),
        ),
      ],
      child: buildMaterialApp(context),
    );
  }

  Widget buildMaterialApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: appRedTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AppNeedInternetAccessState) {
            return AppStartupCheckResultPage(
              message: state.message,
            );
          }

          if (state is AppNeedLocationAccessState) {
            return AppStartupCheckResultPage(
              message: state.message,
            );
          }

          if (state is Unauthenticated) {
            return LoginScreen(
              userRepository: RepositoryProvider.of<UserRepository>(context),
            );
          }

          if (state is AuthenticationUninitializedState ||
              state is PreAuthenticatedState) {
            logger.d(">>>>>>> prepare to load user profile.");
            return GenericLoadingScreen();
          }

          if (state is Authenticated) {
            return MainScreen(
              title: "Hali",
            );
          }

          return SplashScreen();
        },
      ),
      onGenerateRoute: Application.router.generator,
    );
  }
}
