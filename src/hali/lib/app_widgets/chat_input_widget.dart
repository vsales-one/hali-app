import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String, String) onSubmitted;
  final String defaultMessage;
  final String hintMessage;

  const ChatInputWidget(
      {Key key,
      @required this.onSubmitted,
      this.defaultMessage,
      this.hintMessage})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  TextEditingController editingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  @override
  void initState() {
    super.initState();
    editingController.text = this.widget.defaultMessage;
    editingController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: Color(0xff3b5998).withOpacity(0.06),
              borderRadius: BorderRadius.circular(32.0),
            ),
            margin: EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Color(0xff3b5998),
                      ),
                      onPressed: () async {
                        await _getImage();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: this.widget.hintMessage ?? "Message...",
                    ),
                    focusNode: focusNode,
                    textInputAction: TextInputAction.send,
                    controller: editingController,
                    onSubmitted: sendMessage,
                )),
                IconButton(
                  icon: Icon(isTexting ? Icons.send : Icons.keyboard_voice),
                  onPressed: () {
                    sendMessage(editingController.text);
                  },
                  color: Color(0xff3b5998),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool get isTexting => editingController.text.length != 0;

  void sendMessage(String message, {String type = "text"}) {
    if (!isTexting) {
      return;
    }
    widget.onSubmitted(message, type);
    editingController.text = '';
    focusNode.unfocus();
  }

  Future _getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      _uploadFile();
    }
  }

  Future _uploadFile() async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final reference = FirebaseStorage.instance.ref().child(fileName);
    final uploadTask = reference.putFile(imageFile);
    final storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        widget.onSubmitted(imageUrl, "image");
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });      
    });
  }
}
