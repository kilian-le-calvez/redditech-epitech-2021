import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:redditech/widgets/post.dart';
import 'package:redditech/model/profile_indentity_model.dart';
import 'package:redditech/model/subreddit_model.dart';

class PairOption<T1, T2> {
  final T1 lisibleName;
  final T2 queryValue;

  PairOption(this.lisibleName, this.queryValue);
}

class EmailNotificationsSettings {
  Map<String, Map<String, String>> fields = {
    "Messages": {
      "Inbox messages": "email_private_message",
      "Chat requests": "email_chat_request",
    },
    "Activity": {
      "New user welcome": "email_new_user_welcome",
      "Comments on your posts": "email_post_reply",
      "Replies to your comments": "email_comment_reply",
      "Upvotes on your posts": "email_upvote_post",
      "Upvotes on your comments": "email_upvote_comment",
      "Username mentions": "email_username_mention",
      "New followers": "email_user_new_follower",
    },
    "NewsLetters": {
      "Daily Digest": "email_digests",
      "Community Discovery": "email_community_discovery",
    },
    "Others": {
      "Unsubscribe from all emails": "email_unsubscribe_all",
    },
  };
  Map<String, Map<PairOption<String, String>, dynamic>> data = {};

  void setFromMapString(Map<String, dynamic> newData) {
    fields.forEach((category, subMap) {
      data[category] = {};
      subMap.forEach((lisibleName, queryValue) {
        data[category]![PairOption(lisibleName, queryValue)] =
            newData[queryValue];
      });
    });
  }

  void clear() {
    data.clear();
  }
}

class ProfileSettings {
  EmailNotificationsSettings emailNotifications = EmailNotificationsSettings();
  void setSettingsFromResponse(Response<dynamic> response) {
    Map<String, dynamic> data = response.data;
    emailNotifications.setFromMapString(data);
  }

  void clear() {
    emailNotifications.clear();
  }
}

enum HomeStatus { searchSubReddit, searchPost }

class GlobalProvider with ChangeNotifier {
  bool isLoggedIn = false;
  bool isEditingSubReddit = false;
  ProfileIdentity identity = ProfileIdentity();
  ProfileSettings settings = ProfileSettings();
  String code = "";
  String token = "";
  SubReddit currentSubReddit = SubReddit();
  List<Post> listPost = [];
  String afterPostId = "";
  String searchPostType = "";
  String search = "";
  List<SubReddit> listSubRedditHomePage = [];
  List<SubReddit> listSubRedditSubscribed = [];

  GlobalProvider();

  void logOut() {
    isLoggedIn = false;
    identity.clear();
    settings.clear();
    code = "";
    token = "";
    listPost = [];
    search = "";
    listSubRedditHomePage = [];
    listSubRedditSubscribed = [];
    notifyListeners();
  }

  void setSearch(String searchText) {
    search = searchText;
    notifyListeners();
  }

  void setLogged(bool log) {
    isLoggedIn = log;
    notifyListeners();
  }

  void clearParams() {
    settings.clear();
    notifyListeners();
  }

  void setToken(String newToken) {
    token = newToken;
    notifyListeners();
  }

  void setIdentity(ProfileIdentity myIdentity) {
    identity = myIdentity;
    notifyListeners();
  }

  void setSettings(ProfileSettings mySettings) {
    settings = mySettings;
    notifyListeners();
  }

  void setListSubRedditHomePage(List<SubReddit> newListSubReddit) {
    listSubRedditHomePage = newListSubReddit;
    notifyListeners();
  }

  void setListSubRedditSubscribed(List<SubReddit> newListSubReddit) {
    listSubRedditSubscribed = newListSubReddit;
    notifyListeners();
  }

  void actualizeApplication() {
    notifyListeners();
  }

  void setListPost(List<Post> newListPost) {
    listPost += newListPost;
    notifyListeners();
  }

  void setListPostForCurrentSubReddit(List<Post> newListPost) {
    currentSubReddit.listPost += newListPost;
    notifyListeners();
  }
}
