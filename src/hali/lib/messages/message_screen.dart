import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_widgets/chat_input_widget.dart';
import 'package:hali/app_widgets/chat_widget.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:hali/repositories/chat_message_repository.dart';
import 'package:hali/repositories/user_repository.dart';

class MessageScreen extends StatefulWidget {
  final UserProfile friend;

  MessageScreen({
    Key key,
    @required this.friend,
  }) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  ScrollController scrollController = ScrollController();
  UserRepository _userRepository;
  ChatMessageRepository _chatMessageRepository;
  final GlobalKey _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChatMessage> chats = [];
  UserProfile currentUser;
  bool isHeader = true;

  @override
  void initState() {
    super.initState();
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    _chatMessageRepository =
        RepositoryProvider.of<ChatMessageRepository>(context);
    initUser();
    WidgetsBinding.instance.addPostFrameCallback((val) {
      scrollController.addListener(() {
        final RenderBox renderBox = _key.currentContext.findRenderObject();
        final size = renderBox.size;
        double height = size.height * 2 / 3;
        if (scrollController.hasClients)
//        scrollController.animateTo(scrollController.position.maxScrollExtent,
//            duration: Duration(milliseconds: 100), curve: Curves.easeIn);

        if (scrollController.offset >= height) {
          if (mounted) {
            setState(() {
              isHeader = false;
            });
          }
        } else if (!isHeader) {
          if (mounted) {
            setState(() {
              isHeader = true;
            });
          }
        }
      });
    });
  }

  void initUser() async {
    currentUser = await _userRepository.getUserProfile();
    if (mounted) {
      setState(() => 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Theme.of(context).primaryColor,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isHeader
                ? Container(
                    width: 0.0,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.friend.profilePicture,
                        ),
                        radius: 14.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.00),
                        child: Text(
                          widget.friend.displayName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal),
                        ),
                      )
                    ],
                  )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
            color: Theme.of(context).primaryColor,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Info"),
                value: "Info",
              )
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: currentUser == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Flexible(child: buildChats()),
                ChatInputWidget(
                  onSubmitted: (val) {
                    if (currentUser.id == widget.friend.id) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text("You can not send message to you")));
                      return;
                    }
                    ChatMessage chat = ChatMessage.fromNamed(
                        from: currentUser,
                        to: widget.friend,
                        content: val,
                        isSeen: false,
                        publishedAt: DateTime.now());
                    _chatMessageRepository.sendMessage(chat);
                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn);
                    setState(() {
                      chats.add(chat);
                    });
                  },
                )
              ],
            ),
    );
  }

  Widget buildHeader() {
    return Container(
      key: _key,
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(125.0),
            child: Image.network(
              widget.friend.profilePicture,
              height: 125.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.friend.displayName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "${widget.friend.id}",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChats() {
    return StreamBuilder(
        stream: _chatMessageRepository.listenChat(currentUser, widget.friend),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<ChatMessage> chats = snapshot.data;
          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == 0) {
                return buildHeader();
              }
              return ChatWidget(
                chat: chats[index - 1],
                isReceived: currentUser.id != chats[index - 1].from.id,
                showUser: (index == 1) ||
                    (index >= 2 &&
                        !(chats[index - 1].from.id ==
                            chats[index - 2].from.id)),
              );
            },
            itemCount: chats.length + 1,
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
