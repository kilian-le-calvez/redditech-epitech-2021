import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/src/provider.dart';
import 'package:redditech/material/snackbar_error.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/widgets/request.dart';

import 'home_page.dart';

Future<void> waitAndLogOut(BuildContext context) async {
  Future.delayed(const Duration(seconds: 3), () {
    return "";
  }).then((response) {
    context.read<GlobalProvider>().logOut();
    Navigator.pop(context);
  }).catchError((onError) {});
}

class LogOutPage extends StatelessWidget {
  const LogOutPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    waitAndLogOut(context);
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoadingBouncingLine.circle(
          backgroundColor: Colors.black54,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Logging out ..."),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.cancel)),
          ],
        )
      ],
    )));
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LoadingBouncingLine.circle(
          backgroundColor: Colors.black54,
        ),
        const Text("Loading..."),
      ],
    )));
  }
}
