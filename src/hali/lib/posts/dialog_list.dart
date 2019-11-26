// Show Dialog function
import 'package:flutter/material.dart';

class DialogUtils {
  static void _showDialog(context, List<String> values) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          title: new Text('I am Title'),
          content: Container(
              height: 150.0,
              child: new ListView.builder(
                padding: const EdgeInsets.all(4.0),
                itemBuilder: (context, i) {
                  return new ListTile(
                    title: new Text(values[i]),
                    leading: const Icon(Icons.face),
                  );
                },
              )
          ),
        );
      },
    );
  }
}