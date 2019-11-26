import 'package:flutter/material.dart';
import 'package:hali/messages/message_screen.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/item_request_message_type.dart';
import 'package:hali/utils/color_utils.dart';

class RequestListingConfirmationScreen extends StatelessWidget {
  final ItemListingMessage requestItem;
  const RequestListingConfirmationScreen({Key key, this.requestItem})
      : super(key: key);

  static const double LineHeight = 20;
  static const List<String> DoItems = [
    "Say what time you can collect",
    "Message if you're running late",
    "Be respecful to all users"
  ];
  static const List<String> DoNotItems = [
    "Ask for item to be delivered / mailed",
    "Get upset if you don't get anything",
    "Set off for a collection until \r\n 1. It's been confirmed \r\n 2. You have the address \r\n 3. There's an agreed time"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Request listing item",
            style: TextStyle(
                fontSize: 20, color: ColorUtils.hexToColor(color1D1D1D)),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: LineHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.note),
                  Text("To request a listing", style: TextStyle(fontSize: 24),),
                ],
              ),
              SizedBox(
                height: LineHeight,
              ),
              Container(
                color: Colors.blueAccent,
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[Icon(Icons.thumb_up), Text("Do")],
                ),
              ),
              _buildCardCheckList(DoItems),
              SizedBox(
                height: LineHeight,
              ),
              Container(
                color: Colors.redAccent,
                child: Row(
                  children: <Widget>[Icon(Icons.thumb_down), Text("Don't")],
                ),
              ),
              _buildCardCheckList(DoNotItems),
              SizedBox(
                height: LineHeight,
              ),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                    "If you don't follow these guidelines you could get a low star rating and you have your account suspended."),
              ),
              SizedBox(
                height: LineHeight,
              ),
              Container(
                child: RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    "I agree",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MessageScreen(
                        friend: requestItem.to,
                        itemRequestMessage: requestItem,
                        viewMode: ItemRequestMessageViewMode.FirstRequestMessage,
                      )));
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCardCheckList(List<String> items) {
    return Card(
      child: Column(
        children: items.map((title) {
          return CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(title),
            value: false,
            onChanged: (bool value) {},
          );
        }).toList(),
      ),
    );
  }
}
