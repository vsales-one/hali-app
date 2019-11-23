// import 'dart:async';
// import 'dart:io';

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:image_picker/image_picker.dart';

// final googleSignIn = GoogleSignIn();
// final analytics = FirebaseAnalytics();
// final auth = FirebaseAuth.instance;
// var currentUserEmail;
// var _scaffoldContext;

// class MessagesScreen extends StatefulWidget {
//   @override
//   _MessagesScreenState createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> {
//   final TextEditingController _textEditingController =
//       TextEditingController();
//   bool _isComposingMessage = false;
//   // final reference = FirebaseDatabase.instance.reference().child('messages');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Flutter Chat App"),
//           elevation:
//               Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
//           actions: <Widget>[
//             IconButton(
//                 icon: Icon(Icons.exit_to_app), onPressed: _signOut)
//           ],
//         ),
//         body: Container(
//           child: Column(
//             children: <Widget>[
//               Flexible(
//                 child: FirebaseAnimatedList(
//                   query: reference,
//                   padding: const EdgeInsets.all(8.0),
//                   reverse: true,
//                   sort: (a, b) => b.key.compareTo(a.key),
//                   //comparing timestamp of messages to check which one would appear first
//                   itemBuilder: (_, DataSnapshot messageSnapshot,
//                       Animation<double> animation) {
//                     return ChatMessageListItem(
//                       messageSnapshot: messageSnapshot,
//                       animation: animation,
//                     );
//                   },
//                 ),
//               ),
//               Divider(height: 1.0),
//               Container(
//                 decoration:
//                     BoxDecoration(color: Theme.of(context).cardColor),
//                 child: _buildTextComposer(),
//               ),
//               Builder(builder: (BuildContext context) {
//                 _scaffoldContext = context;
//                 return Container(width: 0.0, height: 0.0);
//               })
//             ],
//           ),
//           decoration: Theme.of(context).platform == TargetPlatform.iOS
//               ? BoxDecoration(
//                   border: Border(
//                       top: BorderSide(
//                   color: Colors.grey[200],
//                 )))
//               : null,
//         ));
//   }

//   CupertinoButton getIOSSendButton() {
//     return CupertinoButton(
//       child: Text("Send"),
//       onPressed: _isComposingMessage
//           ? () => _textMessageSubmitted(_textEditingController.text)
//           : null,
//     );
//   }

//   IconButton getDefaultSendButton() {
//     return IconButton(
//       icon: Icon(Icons.send),
//       onPressed: _isComposingMessage
//           ? () => _textMessageSubmitted(_textEditingController.text)
//           : null,
//     );
//   }

//   Widget _buildTextComposer() {
//     return IconTheme(
//         data: IconThemeData(
//           color: _isComposingMessage
//               ? Theme.of(context).accentColor
//               : Theme.of(context).disabledColor,
//         ),
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: Row(
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 4.0),
//                 child: IconButton(
//                     icon: Icon(
//                       Icons.photo_camera,
//                       color: Theme.of(context).accentColor,
//                     ),
//                     onPressed: () async {
//                       await _ensureLoggedIn();
//                       File imageFile = await ImagePicker.pickImage();
//                       int timestamp = DateTime.now().millisecondsSinceEpoch;
//                       StorageReference storageReference = FirebaseStorage
//                           .instance
//                           .ref()
//                           .child("img_" + timestamp.toString() + ".jpg");
//                       StorageUploadTask uploadTask =
//                           storageReference.put(imageFile);
//                       Uri downloadUrl = (await uploadTask.future).downloadUrl;
//                       _sendMessage(
//                           messageText: null, imageUrl: downloadUrl.toString());
//                     }),
//               ),
//               Flexible(
//                 child: TextField(
//                   controller: _textEditingController,
//                   onChanged: (String messageText) {
//                     setState(() {
//                       _isComposingMessage = messageText.length > 0;
//                     });
//                   },
//                   onSubmitted: _textMessageSubmitted,
//                   decoration:
//                       InputDecoration.collapsed(hintText: "Send a message"),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Theme.of(context).platform == TargetPlatform.iOS
//                     ? getIOSSendButton()
//                     : getDefaultSendButton(),
//               ),
//             ],
//           ),
//         ));
//   }

//   Future<Null> _textMessageSubmitted(String text) async {
//     _textEditingController.clear();

//     setState(() {
//       _isComposingMessage = false;
//     });

//     await _ensureLoggedIn();
//     _sendMessage(messageText: text, imageUrl: null);
//   }

//   void _sendMessage({String messageText, String imageUrl}) {
//     reference.push().set({
//       'text': messageText,
//       'email': googleSignIn.currentUser.email,
//       'imageUrl': imageUrl,
//       'senderName': googleSignIn.currentUser.displayName,
//       'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
//     });

//     analytics.logEvent(name: 'send_message');
//   }

//   Future<Null> _ensureLoggedIn() async {
//     GoogleSignInAccount signedInUser = googleSignIn.currentUser;
//     if (signedInUser == null)
//       signedInUser = await googleSignIn.signInSilently();
//     if (signedInUser == null) {
//       await googleSignIn.signIn();
//       analytics.logLogin();
//     }

//     currentUserEmail = googleSignIn.currentUser.email;

//     if (await auth.currentUser() == null) {
//       GoogleSignInAuthentication credentials =
//           await googleSignIn.currentUser.authentication;
//       await auth.signInWithGoogle(
//           idToken: credentials.idToken, accessToken: credentials.accessToken);
//     }
//   }

//   Future _signOut() async {
//     await auth.signOut();
//     googleSignIn.signOut();
//     Scaffold
//         .of(_scaffoldContext)
//         .showSnackBar(SnackBar(content: Text('User logged out')));
//   }
// }