import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoriesWidget extends StatefulWidget {
  final bool rounded;
  const StoriesWidget({Key key, this.rounded = false}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  FirebaseUser user;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    this.user = await FirebaseAuth.instance.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("User stories"),
    );
  }
}
