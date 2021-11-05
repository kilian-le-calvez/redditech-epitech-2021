import 'package:redditech/widgets/post.dart';

class SubReddit {
  late String subRedditTitle;
  late String subRedditId;
  late String subRedditDescription;
  late String subRedditIconImgPath;
  late String subRedditBannerPath;
  late int subRedditNumberSubscriber;
  late bool isSubscribedToSubReddit;
  late List<Post> listPost;
  late String afterPostId;
  final defaultIconImgPath =
      "https://www.toutelasignaletique.com/21751-thickbox_default/lettre-r-minuscule-en-alu-decoupe-coloris-et-dimensions-au-choix.jpg";
  final defaultBannerImgPath = "https://i.redd.it/ax8u9llk8jy61.jpg";
  SubReddit()
      : subRedditTitle = "",
        subRedditId = "",
        subRedditDescription = "",
        subRedditIconImgPath = "",
        subRedditBannerPath = "",
        subRedditNumberSubscriber = 0,
        isSubscribedToSubReddit = false,
        listPost = [],
        afterPostId = "";

  List<dynamic> getSubredditInfo() {
    return [
      subRedditTitle,
      subRedditId,
      subRedditDescription,
      subRedditIconImgPath,
      subRedditBannerPath,
      subRedditNumberSubscriber,
      isSubscribedToSubReddit,
      listPost,
      afterPostId,
    ];
  }

  clear() {
    subRedditTitle = "";
    subRedditId = "";
    subRedditDescription = "";
    subRedditIconImgPath = "";
    subRedditBannerPath = "";
    subRedditNumberSubscriber = 0;
    isSubscribedToSubReddit = false;
    listPost = [];
    afterPostId = "";
  }

  SubReddit.fromChildResponse(dynamic child) {
    if (child["data"] != null) {
      subRedditTitle = child["data"]["display_name_prefixed"] ?? "";
      subRedditId = child["data"]["name"] ?? "";
      subRedditDescription = child["data"]["public_description"] ?? "";
      subRedditIconImgPath = (child["data"]["icon_img"] ?? "") == ""
          ? defaultIconImgPath
          : child["data"]["icon_img"];
      subRedditBannerPath = (child["data"]["banner_img"] ?? "") == ""
          ? defaultBannerImgPath
          : child["data"]["banner_img"];
      subRedditNumberSubscriber = child["data"]["subscribers"] ?? 0;
      isSubscribedToSubReddit = child["data"]["user_is_subscriber"] ?? false;
      listPost = [];
    } else {
      clear();
    }
  }
}
