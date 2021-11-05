import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SnackBar getSnackBarError(String errorMsg) => SnackBar(
      content: Text(errorMsg, textAlign: TextAlign.center),
      backgroundColor: Colors.green[300],
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );

void showSnackBarError(BuildContext context, dynamic errorMsg) {
  ScaffoldMessenger.of(context)
      .showSnackBar(getSnackBarError(errorMsg.toString()));
}
