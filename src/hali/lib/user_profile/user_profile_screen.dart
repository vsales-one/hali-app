import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/authentication_bloc/authentication_bloc.dart';
import 'package:hali/authentication_bloc/bloc.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Center(
        child: RaisedButton(
          child: Text("Sign out"),
          onPressed: () {
            // await RepositoryProvider.of<UserRepository>(context).signOut();
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
          },
        ),
      ),
    );
  }
}
