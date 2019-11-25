import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_widgets/chat_input_widget.dart';
import 'package:hali/app_widgets/chat_widget.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/item_request_message_type.dart';
import 'package:hali/models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:hali/repositories/chat_message_repository.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/utils/alert_helper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MessageScreen extends StatefulWidget {
  final UserProfile friend;
  final ItemListingMessage itemRequestMessage;
  final ItemRequestMessageViewMode viewMode;

  MessageScreen(
      {Key key,
      @required this.friend,
      this.itemRequestMessage,
      this.viewMode = ItemRequestMessageViewMode.ChatMessage})
      : super(key: key);

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
      appBar: _buildAppBar(),
      body: widget.viewMode == ItemRequestMessageViewMode.FirstRequestMessage
          ? _buildFirstRequestMessageViewMode()
          : _buildChatMessageViewMode(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
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
    );
  }

  Widget _buildFirstRequestMessageViewMode() {
    final friend = widget.friend;
    return currentUser == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(          
            child: ModalProgressHUD(
              child: Column(               
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: ListView(
                      children: <Widget>[
                        _buildFriendAvatar(friend),
                        _buildFriendFullName(friend),
                        _buildFriendLocation(friend),
                        SizedBox(height: 20,),
                        _buildFirstMessageToolTipCard(),
                      ],
                    ),
                  ),
                  // _buildFriendAvatar(friend),
                  // _buildFriendFullName(friend),
                  // _buildFriendLocation(friend),
                  // SizedBox(height: 20,),
                  // Expanded(
                  //   child: _buildFirstMessageToolTipCard(),
                  // ),
                  // _buildFirstMessageToolTipCard(),
                  _buildRequestMessageInput(),                  
                ],
              ), 
              inAsyncCall: currentUser == null,
            ),
          );
  }

  Widget _buildFriendAvatar(UserProfile friendUser) {
    return GestureDetector(
      child: Hero(
        tag: 'hero',
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 64.0,
            backgroundColor: Colors.transparent,
            backgroundImage:
                friendUser != null && friendUser.profilePicture.isNotEmpty
                    ? NetworkImage(friendUser.profilePicture)
                    : AssetImage('assets/hali_logo_199.png'),
          ),
        ),
      ),
      onTap: () {},
    );
  }

  Widget _buildFriendFullName(UserProfile friendUser) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        friendUser.displayName ?? '',
        key: Key('user_fullname'),
        style: TextStyle(fontSize: 24.0, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildFriendLocation(UserProfile friendUser) {    
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.location_on),
          Text("2.8 km away"),
        ],
      ),
    );        
  }

  Widget _buildFirstMessageToolTipCard() {
    return Card(
      margin: EdgeInsets.only(left: 8, right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,            
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: Text("Tool tips", style: TextStyle(fontWeight: FontWeight.bold,),),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text("- Say when you can pickup this listing"),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text("Be polite by saying please and thank you"),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text("Never set off without the pickup confirmed, and an address"),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestMessageInput() {
    return ChatInputWidget(
      defaultMessage: "Hi ${widget.itemRequestMessage.to.displayName},",
      onSubmitted: (val) async {
        print(">>>>>>> sending message: $val");
        final sendResOk = await _chatMessageRepository.sendItemRequestMessage(widget.itemRequestMessage);
        if(sendResOk) {
          AlertHelper.showAlertInfo(context, "Success! your request of the item has been sent.");
        }
      },
    );
  }

  Widget _buildChatMessageViewMode() {
    return currentUser == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: <Widget>[
              Flexible(child: _buildChatMessages()),
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
          );
  }

  Widget _buildChatMessageHeader() {
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

  Widget _buildChatMessages() {
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
                return _buildChatMessageHeader();
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
