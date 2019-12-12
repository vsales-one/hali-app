import 'package:flutter/material.dart';

class GenericErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          children: [
            Icon(
              Icons.error,
              size: 36,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Có lỗi xảy ra vui lòng thử lại'),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
