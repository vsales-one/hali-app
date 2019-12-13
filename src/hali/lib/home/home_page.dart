import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/home/index.dart';
import 'package:hali/repositories/user_repository.dart';

class HomePage extends StatelessWidget {
  final UserRepository _userRepository;
  final HomeRepository _homeRepository;
  final int _categoryId;
  final String _title;

  HomePage(
      {Key key,
      @required UserRepository userRepository,
      @required HomeRepository homeRepository,
      @required int categoryId,
      @required String title})
      : assert(userRepository != null || homeRepository != null),
        _userRepository = userRepository,
        _homeRepository = homeRepository,
        _categoryId = categoryId ?? 1,
        _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => HomeBloc(
        userRepository: _userRepository,
        homeRepository: _homeRepository,
      ),
      child: HomeScreen(
        name: _title,
        categoryId: _categoryId,
      ),
    );
  }
}
