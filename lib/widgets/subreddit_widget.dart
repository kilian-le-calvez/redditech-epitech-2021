import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/material/snackbar_error.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/widgets/profile_logged.dart';
import 'package:redditech/widgets/request.dart';
import 'package:redditech/model/subreddit_model.dart';

String cutTo100Chars(String str) {
  int end = str.length;
  String finish = end > 100 ? "..." : "";
  end = end > 100 ? 100 : end;
  String res = str.substring(0, end) + finish;
  res.replaceAll("\n", "");
  return str.substring(0, end) + finish;
}

class SubRedditWidget extends StatefulWidget {
  final SubReddit subReddit;

  SubRedditWidget({required this.subReddit, Key? key}) : super(key: key);
  @override
  _SubRedditWidgetState createState() => _SubRedditWidgetState();
}

class _SubRedditWidgetState extends State<SubRedditWidget> {
  bool isDetailled = false;

  void displayOrHideDescription() {
    setState(() {
      isDetailled = !isDetailled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Card(
          child: Column(children: <Widget>[
        GestureDetector(
            onTap: () {
              context.read<GlobalProvider>().currentSubReddit =
                  widget.subReddit;
              Navigator.pushNamed(context, '/subreddit');
            },
            child: Container(
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                            widget.subReddit.subRedditBannerPath))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(width: 15),
                          ProfilePictureWidget(
                            width: 30,
                            height: 30,
                            borderWidth: 1,
                            path: widget.subReddit.subRedditIconImgPath,
                          ),
                          IconButton(
                              onPressed: () {
                                displayOrHideDescription();
                              },
                              icon: const Icon(Icons.info,
                                  color: Colors.white, size: 30)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Text(widget.subReddit.subRedditTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600))),
                            const SizedBox(width: 10, height: 10),
                            if (context
                                .read<GlobalProvider>()
                                .isEditingSubReddit)
                              GestureDetector(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 5),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: widget
                                            .subReddit.isSubscribedToSubReddit
                                        ? const Text("Leave",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w600))
                                        : const Text("Join",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600))),
                                onTap: () {
                                  NewApiServices()
                                      .subscribeSubReddit(
                                          context.read<GlobalProvider>().token,
                                          !widget.subReddit
                                              .isSubscribedToSubReddit,
                                          widget.subReddit.subRedditId)
                                      .then((response) {
                                    widget.subReddit.isSubscribedToSubReddit =
                                        !widget
                                            .subReddit.isSubscribedToSubReddit;
                                    context
                                        .read<GlobalProvider>()
                                        .actualizeApplication();
                                  }).catchError((onError) {
                                    showSnackBarError(context, onError);
                                  });
                                },
                              )
                          ])
                    ]))),
        if (isDetailled)
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                        widget.subReddit.subRedditNumberSubscriber.toString() +
                            " subscribers",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black))),
                Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                        cutTo100Chars(widget.subReddit.subRedditDescription),
                        textAlign: TextAlign.center)),
              ]),
      ]));
    });
  }
}
