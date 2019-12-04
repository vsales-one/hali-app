import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/app_widgets/chat_input_widget.dart';
import 'package:hali/app_widgets/chat_widget.dart';
import 'package:hali/config/routes.dart';
import 'package:hali/messages/widgets/chat_message_header.dart';
import 'package:hali/messages/widgets/first_message_tooltip.dart';
import 'package:hali/messages/widgets/request_item_info.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/item_request_message_type.dart';
import 'package:hali/models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:hali/repositories/chat_message_repository.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:hali/utils/alert_helper.dart';
import 'package:hali/utils/color_utils.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  // final GlobalKey _firstRequestMessageHeaderKey = GlobalKey();
  // final GlobalKey _messageHeaderKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ChatMessage> chats = [];
  UserProfile currentUser;
  bool isHeader = true;
  bool isProcessing = false;
  bool isPickupPendingApproval = true;

  @override
  void initState() {
    super.initState();
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    _chatMessageRepository =
        RepositoryProvider.of<ChatMessageRepository>(context);
    initUser();
    var messageStatus = widget.itemRequestMessage.status;
    print(">>>>>>> message status: $messageStatus");
    if ((messageStatus == ItemRequestMessageStatus.Open || messageStatus == null ||
        messageStatus.toString().isEmpty)) {
      isPickupPendingApproval = true;
    } else {
      isPickupPendingApproval = false;
    }
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
      backgroundColor: ColorUtils.hexToColor(colorD92c27),
      elevation: 1.0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
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
                        widget.friend.imageUrl,
                      ),
                      radius: 14.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.00),
                      child: Text(
                        widget.friend.firstName,
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
          color: Theme.of(context).accentIconTheme.color,
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
          color: Theme.of(context).accentIconTheme.color,
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
            color: Theme.of(context).accentIconTheme.color,
          ),
        )
      ],
    );
  }

  // In this view mode, requestor send first request message to item owner
  // the message header is different from normal view mode
  Widget _buildFirstRequestMessageViewMode() {
    return currentUser == null || isProcessing
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
                        ChatMessageHeader(
                            // key: _firstRequestMessageHeaderKey,
                            user: widget.friend),
                        RequestItemInfo(
                          itemListingMessage: widget.itemRequestMessage,
                        ),
                        FirstMessageTooltip(),
                      ],
                    ),
                  ),
                  _buildRequestMessageInput(),
                ],
              ),
              inAsyncCall: currentUser == null,
            ),
          );
  }

  Widget _buildRequestMessageInput() {
    return ChatInputWidget(
      defaultMessage: "Xin chào ${widget.itemRequestMessage.to.displayName},",
      onSubmitted: (message) async {
        print(">>>>>>> sending message: $message");
        setState(() {
          isProcessing = true;
        });
        final sendResOk = await _chatMessageRepository.sendItemRequestMessage(
            message, widget.itemRequestMessage);
        setState(() {
          isProcessing = false;
        });
        if (sendResOk) {
          await AlertHelper.showAlertInfo(
              context, "Tin nhắn của bạn đã được gửi");
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.root));
        }
      },
    );
  }

  Widget _buildChatMessageViewMode() {
    return currentUser == null || isProcessing
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: <Widget>[
              Flexible(child: _buildChatMessages()),
              ChatInputWidget(
                hintMessage: "Gửi tin nhắn đến ${widget.friend.firstName}",
                onSubmitted: (val) {
                  if (currentUser.userId == widget.friend.userId) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content:
                            Text("Bạn không thể gửi tin nhắn cho chính mình")));
                    return;
                  }
                  ChatMessage chat = ChatMessage.fromNamed(
                      from: currentUser,
                      to: widget.friend,
                      content: val,
                      isSeen: false,
                      publishedAt: DateTime.now(),
                      groupId: widget.itemRequestMessage.groupId);
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

  Widget _buildActionButtons(ItemListingMessage itemRequestMessage) {
    if (currentUser.userId == itemRequestMessage.from.userId) {
      // view message as requestor
      return Container();
    }
    // view message as item owner
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Xác nhận ${itemRequestMessage.from.firstName} đã nhận được \r\n${itemRequestMessage.itemTitle}.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.body2.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          isPickupPendingApproval
              ? _buildConfirmationApprovalButton()
              : _buildCancelApprovalButton(widget.friend),
        ],
      ),
    );
  }

  Widget _buildConfirmationApprovalButton() {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Text(
        "Xác Nhận",
        style: TextStyle(
          color: Theme.of(context).accentIconTheme.color,
        ),
      ),
      onPressed: () => showItemOwnerPickupApproval(context),
    );
  }

  Widget _buildCancelApprovalButton(UserProfile user) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Text(
        "Thay Đổi",
        style: TextStyle(
          color: Theme.of(context).accentIconTheme.color,
        ),
      ),
      onPressed: () => showItemOwnerCancelPickup(context, user),
    );
  }

  void showItemOwnerPickupApproval(BuildContext context) {
    Alert(
        context: context,
        title: 'Xác Nhận',
        desc: "Xác nhận quà đã được cho",
        buttons: [
          DialogButton(
            child: Text(
              "Đồng ý và ẩn bài viết",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              await _chatMessageRepository
                  .confirmItemPickupAndClosePost(widget.itemRequestMessage);
              setState(() {
                isPickupPendingApproval = false;
              });
              Navigator.pop(context);
            },
          ),
        ]).show();
  }

  void showItemOwnerCancelPickup(BuildContext context, UserProfile user) {
    Alert(
        context: context,
        title: 'Xác Nhận',
        desc: "Bạn không muốn cho món quà này đến ${user.firstName} nữa",
        buttons: [
          DialogButton(
            child: Text(
              "Đồng ý và hiển thị lại bài viết",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              await _chatMessageRepository
                  .cancelItemPickupAndReopenPost(widget.itemRequestMessage);
              setState(() {
                isPickupPendingApproval = true;
              });
              Navigator.pop(context);
            },
          ),
        ]).show();
  }

  Widget _buildChatMessages() {
    return StreamBuilder(
        stream: _chatMessageRepository
            .listenChat(widget.itemRequestMessage.groupId),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<ChatMessage> chats = snapshot.data;
          final totalItemCount = chats.length + 2;
          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ChatMessageHeader(
                  // key: _messageHeaderKey,
                  user: widget.friend,
                );
              }
              if (index == totalItemCount - 1) {
                return _buildActionButtons(widget.itemRequestMessage);
              }
              final messageData = chats[index - 1];
              return ChatWidget(
                chat: messageData,
                isReceived: currentUser.userId != messageData.from.userId,
                showUser: (index == 1) ||
                    (index >= 2 &&
                        !(messageData.from.userId == messageData.from.userId)),
              );
            },
            itemCount: totalItemCount,
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
