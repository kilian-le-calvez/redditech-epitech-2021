import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redditech/material/snackbar_error.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/widgets/post.dart';
import 'package:redditech/widgets/post_widget.dart';
import 'package:redditech/widgets/profile_logged.dart';
import 'package:redditech/widgets/request.dart';
import 'package:redditech/widgets/subreddit_widget.dart';

class HeadSubReddit extends StatelessWidget {
  const HeadSubReddit({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Column(children: <Widget>[
        Container(
            height: 150,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(context
                        .read<GlobalProvider>()
                        .currentSubReddit
                        .subRedditBannerPath))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black, Colors.transparent],
                          ).createShader(Rect.fromLTRB(rect.width * 0.75,
                              rect.height * 0.75, rect.width, rect.height));
                        },
                        blendMode: BlendMode.dstIn,
                        child: ProfilePictureWidget(
                          width: 100,
                          height: 100,
                          borderWidth: 3,
                          path: context
                              .read<GlobalProvider>()
                              .currentSubReddit
                              .subRedditIconImgPath,
                        ),
                      ),
                    ],
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              NewApiServices()
                                  .subscribeSubReddit(
                                      context.read<GlobalProvider>().token,
                                      !context
                                          .read<GlobalProvider>()
                                          .currentSubReddit
                                          .isSubscribedToSubReddit,
                                      context
                                          .read<GlobalProvider>()
                                          .currentSubReddit
                                          .subRedditId)
                                  .then((response) {
                                context
                                        .read<GlobalProvider>()
                                        .currentSubReddit
                                        .isSubscribedToSubReddit =
                                    !context
                                        .read<GlobalProvider>()
                                        .currentSubReddit
                                        .isSubscribedToSubReddit;
                                context
                                    .read<GlobalProvider>()
                                    .actualizeApplication();
                              }).catchError((onError) {
                                showSnackBarError(context, onError);
                              });
                            },
                            icon: context
                                    .read<GlobalProvider>()
                                    .currentSubReddit
                                    .isSubscribedToSubReddit
                                ? const Icon(Icons.add_circle,
                                    color: Colors.white)
                                : const Icon(Icons.add_circle_outline,
                                    color: Colors.white)),
                        context
                                .read<GlobalProvider>()
                                .currentSubReddit
                                .isSubscribedToSubReddit
                            ? const Text("Leave",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10))
                            : const Text("Join",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))
                      ]),
                ])),
        Container(
            child: Text(
          context.read<GlobalProvider>().currentSubReddit.subRedditTitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        )),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
              '${context.read<GlobalProvider>().currentSubReddit.subRedditNumberSubscriber} subscribers'),
          IconButton(onPressed: () {}, icon: const Icon(Icons.people))
        ]),
        Container(
          height: 50,
          margin: const EdgeInsets.all(10),
          child: ListView(padding: EdgeInsets.all(5), children: <Widget>[
            Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                child: Text(
                    context
                        .read<GlobalProvider>()
                        .currentSubReddit
                        .subRedditDescription,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ))),
          ]),
        ),
      ]);
    });
  }
}

class SubRedditPage extends StatelessWidget {
  const SubRedditPage({Key? key}) : super(key: key);

  void searchNewPostFromSubReddit(
      BuildContext context, String searchType, String subReddit) {
    if (context.read<GlobalProvider>().searchPostType != searchType) {
      context.read<GlobalProvider>().searchPostType = searchType;
      context.read<GlobalProvider>().currentSubReddit.listPost = [];
    }
    var params =
        context.read<GlobalProvider>().currentSubReddit.listPost.isEmpty
            ? "?limit=99"
            : "?after=" +
                context.read<GlobalProvider>().currentSubReddit.afterPostId +
                "&count=" +
                context
                    .read<GlobalProvider>()
                    .currentSubReddit
                    .listPost
                    .length
                    .toString() +
                "&limit=99";
    NewApiServices()
        .searchPost(
            context.read<GlobalProvider>().token, searchType, params, subReddit)
        .then((listAfterAndPost) {
      context
          .read<GlobalProvider>()
          .setListPostForCurrentSubReddit(listAfterAndPost.queryValue);
      context.read<GlobalProvider>().currentSubReddit.afterPostId =
          listAfterAndPost.lisibleName;
      print(context.read<GlobalProvider>().currentSubReddit.afterPostId);
    }).catchError((onError) {
      showSnackBarError(context, onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    searchNewPostFromSubReddit(context, "",
        context.read<GlobalProvider>().currentSubReddit.subRedditTitle);

    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Scaffold(
          body: Column(children: [
        const HeadSubReddit(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (String nameButton in ["hot", "new", "top"])
              ElevatedButton(
                  onPressed: () {
                    searchNewPostFromSubReddit(
                        context,
                        nameButton,
                        context
                            .read<GlobalProvider>()
                            .currentSubReddit
                            .subRedditTitle);
                    context.read<GlobalProvider>().actualizeApplication();
                  },
                  child: Text(nameButton),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black38))),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: ListView(children: <Widget>[
              for (Post post
                  in context.read<GlobalProvider>().currentSubReddit.listPost)
                PostWidget(postReddit: post),
              ElevatedButton(
                  onPressed: () {
                    searchNewPostFromSubReddit(
                        context,
                        context.read<GlobalProvider>().searchPostType,
                        context
                            .read<GlobalProvider>()
                            .currentSubReddit
                            .subRedditTitle);
                  },
                  child: Text("Load more posts"),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey))),
            ]),
          ),
        ),
      ]));
    });
  }
}
