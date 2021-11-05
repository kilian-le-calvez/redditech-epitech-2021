const imageType = "image";
const videoType = "hosted:video";
const linkType = "link";

class Post {
  String postTitle = "";
  String postMediaPath = "";
  String postAuthorName = "";
  String postSubRedditTitle = "";
  String postSubRedditId = "";
  int postUps = 0;
  int postDowns = 0;
  String postMediaType = "";
  bool postIsVideo = false;
  String postId = "";
  String postAuthorId = "";
  Post();

  setPostFromChildResponse(dynamic child) {
    postTitle = child["data"]["title"] ?? "";
    postAuthorName = child["data"]["author"] ?? "";
    postSubRedditTitle = child["data"]["subreddit_name_prefixed"] ?? "";
    postSubRedditId = child["data"]["subreddit_id"] ?? "";
    postUps = child["data"]["ups"] ?? "";
    postDowns = child["data"]["downs"] ?? "";
    postMediaType = child["data"]["post_hint"] ?? "";
    postIsVideo = child["data"]["is_video"] ?? "";
    if (child["data"]["secure_media"] != null) {
      if (child["data"]["secure_media"]["reddit_video"] != null) {
        postMediaPath =
            child["data"]["secure_media"]["reddit_video"]["fallback_url"] ?? "";
      } else if (child["data"]["secure_media"]["oembed"] != null) {
        postMediaPath = child["data"]["url_overridden_by_dest"] ?? "";
      }
    } else {
      postMediaPath = child["data"]["url"] ?? "";
    }
    postId = child["data"]["name"] ?? "";
    postAuthorId = child["data"]["author_fullname"] ?? "";
  }
}
