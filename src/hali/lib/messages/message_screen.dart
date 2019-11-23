import 'package:flutter/material.dart';
import 'package:hali/models/user_profile.dart';

class MessageScreen extends StatefulWidget {
  final UserProfile friend;

  const MessageScreen({Key key, this.friend}) : super(key: key);

  @override
  _MessageScreenScreenState createState() => _MessageScreenScreenState();
}

class _MessageScreenScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("chat message"),);
  }
}
