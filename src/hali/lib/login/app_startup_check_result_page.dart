import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppStartupCheckResultPage extends StatelessWidget {
  static const String routeName = "/app_startup_check_result";
  final String message;

  const AppStartupCheckResultPage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Thông Báo"),
        ),
        body: Center(          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(this.message, textAlign: TextAlign.center,),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: RaisedButton(
                      child: Text('Thoát', style: TextStyle(color: Colors.white),),
                      color: Colors.redAccent,
                      onPressed: _exitApp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }  

  _exitApp() => exit(0);
}
