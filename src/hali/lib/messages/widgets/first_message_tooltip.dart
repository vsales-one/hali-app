import 'package:flutter/material.dart';

class FirstMessageTooltip extends StatelessWidget {
  const FirstMessageTooltip({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildFirstMessageToolTipCard();
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
            child: Text(
              "Trợ giúp",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text("- Cho biết khi nào bạn có thể đến nhận quà."),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
                "- Hãy hành động lịch sự và cảm ơn những người đã chia sẽ."),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
                "- Hãy đến nhận quà khi bạn đã có đủ thông tin về thời gian và địa điểm."),
          ),
        ],
      ),
    );
  }
}
