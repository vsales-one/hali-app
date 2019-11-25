import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertHelper {
  static void showAlertInfo(BuildContext context, String message) {
    Alert(context: context, title: 'Thông báo', desc: message, buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ]).show();
  }

  static void showAlertError(BuildContext context, String error) {
    Alert(
      context: context, 
      title: 'Lỗi', 
      desc: error, 
      type: AlertType.error,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
    ]).show();
  }
}
