import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redditech/widgets/post.dart';
import 'package:redditech/widgets/video_widget.dart';
import 'package:url_launcher/url_launcher.dart';

dynamic loadMediaFromPost(Post post) {
  if (post.postMediaType == "image") {
    return Image(image: NetworkImage(post.postMediaPath));
  } else if (post.postMediaType == "hosted:video") {
    return Column(children: [
      VideoApp(
        videoLink: post.postMediaPath,
      ),
    ]);
  } else {
    return InkWell(
        onTap: () {
          launch(post.postMediaPath);
        },
        child: Text(
          post.postMediaPath,
          style: const TextStyle(color: Colors.blue),
        ));
  }
}

class PostWidget extends StatelessWidget {
  final Post postReddit;
  const PostWidget({required this.postReddit, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {},
                              child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
                                  child: Text(postReddit.postSubRedditTitle))),
                          GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                child: Text(
                                    "Author : " + postReddit.postAuthorName),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Title : " + postReddit.postTitle,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ]),
                      Container(
                        child: loadMediaFromPost(postReddit),
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("Ups : " + postReddit.postUps.toString()),
                              Text(
                                  "Downs : " + postReddit.postDowns.toString()),
                            ],
                          )
                        ],
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
