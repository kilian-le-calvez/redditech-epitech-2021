import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:redditech/material/snackbar_error.dart';
import 'package:redditech/widgets/button.dart';
import 'package:redditech/widgets/navigation_bar.dart';
import 'package:redditech/widgets/post.dart';
import 'package:redditech/widgets/post_widget.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/widgets/profile_logged.dart';
import 'package:redditech/widgets/request.dart';
import 'package:redditech/pages/subreddit_page.dart';

void searchNewPost(BuildContext context, String searchType) {
  if (context.read<GlobalProvider>().searchPostType != searchType) {
    context.read<GlobalProvider>().searchPostType = searchType;
    context.read<GlobalProvider>().listPost = [];
  }
  var params = context.read<GlobalProvider>().listPost.isEmpty
      ? "?limit=99"
      : "?after=" +
          context.read<GlobalProvider>().afterPostId +
          "&count=" +
          context.read<GlobalProvider>().listPost.length.toString() +
          "&limit=99";
  NewApiServices()
      .searchPost(context.read<GlobalProvider>().token, searchType, params, "")
      .then((listAfterAndPost) {
    context.read<GlobalProvider>().setListPost(listAfterAndPost.queryValue);
    context.read<GlobalProvider>().afterPostId = listAfterAndPost.lisibleName;
    print(context.read<GlobalProvider>().afterPostId);
  }).catchError((onError) {
    if (context.read<GlobalProvider>().isLoggedIn == false) {
      showSnackBarError(context, "You may are not connected !");
    }
    showSnackBarError(context, onError);
  });
}

class SearchPostButton extends StatelessWidget {
  final String searchType;

  const SearchPostButton({required this.searchType, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => {searchNewPost(context, searchType)},
        child: Text(searchType),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black38)));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
        builder: (BuildContext context, GlobalProvider info, Widget? child) {
      return Scaffold(
        appBar: NavigationBar(context: context),
        drawer: Drawer(
            child: Container(
                decoration: BoxDecoration(color: Colors.black54),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                          ),
                          height: 500,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: DrawerHeader(
                                        margin: EdgeInsets.all(0),
                                        padding: EdgeInsets.all(0),

                                        //photo ici
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/profile');
                                            },
                                            child: Column(children: <Widget>[
                                              Text(
                                                (context
                                                            .read<
                                                                GlobalProvider>()
                                                            .identity
                                                            .profileName !=
                                                        "")
                                                    ? context
                                                        .read<GlobalProvider>()
                                                        .identity
                                                        .profileName
                                                    : "Anonymous",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 24,
                                                ),
                                                // karma
                                              ),
                                              const SizedBox(height: 15),
                                              ProfilePictureWidget(
                                                  width: 100,
                                                  height: 100,
                                                  borderWidth: 3,
                                                  path: context
                                                              .read<
                                                                  GlobalProvider>()
                                                              .identity
                                                              .profilePicturePath !=
                                                          ""
                                                      ? context
                                                          .read<
                                                              GlobalProvider>()
                                                          .identity
                                                          .profilePicturePath
                                                      : context
                                                          .read<
                                                              GlobalProvider>()
                                                          .currentSubReddit
                                                          .defaultIconImgPath)
                                            ]))))
                              ])),
                      Column(
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Colors.black,
                                      Colors.black54,
                                      Colors.black,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/profile');
                                },
                                child: const Text(" My Profile ",
                                    style: TextStyle(color: Colors.white))),
                          ]),
                          const SizedBox(height: 30),
                          Stack(children: <Widget>[
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0),
                                  ),
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Colors.black,
                                      Colors.black54,
                                      Colors.black,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/settings');
                                },
                                child: const Text("My Settings",
                                    style: TextStyle(color: Colors.white))),
                          ]),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ]))),
        body: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                context.read<GlobalProvider>().isLoggedIn
                    ? Text("Home - Stay connected")
                    : Text("Home - You should be connected !"),
                context.read<GlobalProvider>().isLoggedIn
                    ? IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/logout');
                        },
                        icon: Icon(Icons.power_outlined))
                    : IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        icon: Icon(Icons.power_off_outlined)),
                Text(";)"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const <Widget>[
              SearchPostButton(searchType: "hot"),
              SearchPostButton(searchType: "new"),
              SearchPostButton(searchType: "top"),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: ListView(children: <Widget>[
                for (Post post in context.read<GlobalProvider>().listPost)
                  PostWidget(postReddit: post),
                ElevatedButton(
                    onPressed: () {
                      searchNewPost(context,
                          context.read<GlobalProvider>().searchPostType);
                    },
                    child: const Text("Load more posts"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey))),
              ]),
            ),
          ),
        ]),
      );
    });
  }
}
