import 'package:flutter/material.dart';

class EmptyListing extends StatelessWidget {
  final String noDataMessage;
  final Image icon;

  const EmptyListing({Key key, this.noDataMessage, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final message = this.noDataMessage != null && this.noDataMessage.isNotEmpty
        ? this.noDataMessage
        : "Không có dữ liệu nào";
    final image = this.icon != null
        ? this.icon
        : Image.asset('assets/images/ic-empty.png');
    return Center(
      child: Container(
        child: Column(
          children: [
            image,
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(message),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
