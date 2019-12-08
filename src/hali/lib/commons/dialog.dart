import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hali/authentication_bloc/bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<T> _showAlert<T>({BuildContext context, Widget child}) => showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    );


Future<bool> showAlert(BuildContext context,
        {String title,
        String negativeText = "Cancel",
        String positiveText = "Confirm",
        bool onlyPositive = false}) =>
    _showAlert<bool>(
      context: context,
      child: CupertinoAlertDialog(
        title: Text(title),
        actions: _buildAlertActions(
            context, onlyPositive, negativeText, positiveText),
      ),
    );

List<Widget> _buildAlertActions(BuildContext context, bool onlyPositive,
    String negativeText, String positiveText) {
  if (onlyPositive) {
    return [
      CupertinoDialogAction(
        child: Text(
          positiveText,
          style: TextStyle(fontSize: 18.0),
        ),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    ];
  } else {
    return [
      CupertinoDialogAction(
        child: Text(
          negativeText,
          style: TextStyle(color: Color(0xFF71747E), fontSize: 18.0),
        ),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
      CupertinoDialogAction(
        child: Text(
          positiveText,
          style: TextStyle(fontSize: 18.0),
        ),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
    ];
  }
}


Future _showLoadingDialog(BuildContext c, LoadingDialog loading,
        {bool cancelable = true}) =>
    showDialog(
        context: c,
        barrierDismissible: cancelable,
        builder: (BuildContext c) => loading);

class LoadingDialog extends CupertinoAlertDialog {
  BuildContext parentContext;
  BuildContext currentContext;
  bool showing;
  show(BuildContext context) {
    parentContext = context;
    showing = true;
    _showLoadingDialog(context, this).then((_){
        showing=false;
    });
  }

  hide() {
    if(showing) {
      Navigator.removeRoute(parentContext, ModalRoute.of(currentContext));
    }
  }

  @override
  Widget build(BuildContext context) {
    currentContext= context;
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: Container(
              width: 120,
              height: 120,
              child: CupertinoPopupSurface(
                child: Semantics(
                  namesRoute: true,
                  scopesRoute: true,
                  explicitChildNodes: true,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

displayAlertError(BuildContext context, String title, DioError error, String message) {
  Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            Navigator.pop(context);
            
            if (error.response == null || error.response.statusCode == 401) {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            }
          },
          width: 120,
        )
      ],
    ).show();
}