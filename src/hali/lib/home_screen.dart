import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/authentication_bloc/bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _SliverCategory()
        ],
      ),
    );
  }
}

class _SliverCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(icon: Icon(MdiIcons.filterMenuOutline), onPressed: null),
                  IconButton(icon: Icon(Icons.dashboard),)
                ],
              )
            )
        )
    );
  }
  
}
