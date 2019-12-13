import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/messages/message_screen.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/item_request_message_type.dart';
import 'package:hali/utils/color_utils.dart';

class RequestListingConfirmationScreen extends StatefulWidget {
  final ItemListingMessage requestItem;

  RequestListingConfirmationScreen({Key key, this.requestItem})
      : super(key: key);

  @override
  _RequestListingConfirmationScreenState createState() =>
      _RequestListingConfirmationScreenState();
}

class _RequestListingConfirmationScreenState
    extends State<RequestListingConfirmationScreen> {
  static const double LineHeight = 20;
  static const List<String> DoItems = [
    "Cho biết thời gian bạn đến nhận quà",
    "Hãy thông báo nếu bạn đến muộn",
    "Hãy tôn trọng tất cả người dùng"
  ];
  static const List<String> DoNotItems = [
    "Yêu cầu quà được gửi đến tận nơi",
    "Cảm thấy buồn khi bạn không nhận được quà như ý",
    "Đến nhận quà khi \r\n 1. Chưa được người cho xác nhận \r\n 2. Chưa có địa chỉ rõ ràng \r\n 3. Chưa có sự đồng ý về thời gian nhận"
  ];

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    logger.d(">>>>>>> confirm to request for item ${widget.requestItem.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        backgroundColor: ColorUtils.hexToColor(colorD92c27),
      ),
      backgroundColor: ColorUtils.hexToColor(colorD92c27),
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FormBuilder(
      key: _fbKey,
      autovalidate: true,
      child: _buildFormBody(context),
    );
  }

  Widget _buildFormBody(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: LineHeight,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.note,
                  color: Colors.white,
                ),
              ),
              Text(
                "Để yêu cầu nhận quà",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: LineHeight,
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.thumb_up,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Việc Phải Làm",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          _buildCardCheckList("DoItems", DoItems),
          SizedBox(
            height: LineHeight,
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.thumb_down,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Việc Không Nên Làm",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          _buildCardCheckList("DoNotItems", DoNotItems),
          SizedBox(
            height: LineHeight,
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              "Nếu bạn không tuân theo các quy định cộng đồng của Hali bạn có thể bị đánh giá thấp và có thể bị khoá tài khoản.",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: LineHeight,
          ),
          Container(
            child: RaisedButton(
              color: Colors.white,
              child: Text(
                "Tôi Đồng Ý Với Các Điều Khoản Trên",
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: _onConfirmButtonPressed,
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirmButtonPressed() {
    if (_fbKey.currentState.saveAndValidate()) {
      final shouldDoItems = _fbKey.currentState.value["DoItems"] as List;
      final shouldNotDoItems = _fbKey.currentState.value["DoNotItems"] as List;
      if (shouldDoItems.length != 3 || shouldNotDoItems.length != 3) {
        _globalKey.currentState
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("Bạn chưa đồng ý với các điều khoản ở trên"),
            ),
          );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              friend: widget.requestItem.to,
              itemRequestMessage: widget.requestItem,
              viewMode: ItemRequestMessageViewMode.FirstRequestMessage,
            ),
          ),
        );
      }
    }
  }

  Widget _buildCardCheckList(String attribute, List<String> items) {
    final options = items.map((title) {
      return FormBuilderFieldOption(
        value: title,
      );
    }).toList();
    return Card(
      color: Colors.white,
      child: FormBuilderCheckboxList(
        decoration: InputDecoration(labelText: ""),
        leadingInput: true,
        attribute: attribute,
        options: options,
      ),
    );
  }
}
