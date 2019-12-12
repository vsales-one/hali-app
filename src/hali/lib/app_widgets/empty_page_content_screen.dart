import 'package:flutter/material.dart';

class EmptyPageContentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Image.asset('assets/images/ic-empty.png'),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Không có dữ liệu nào'),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
