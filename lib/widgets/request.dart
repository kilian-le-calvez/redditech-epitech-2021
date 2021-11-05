import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'package:redditech/widgets/post.dart';
import 'package:redditech/widgets/global_info.dart';
import 'package:redditech/model/profile_indentity_model.dart';
import 'package:redditech/model/subreddit_model.dart';
import 'package:redditech/model/auth_info.dart' as ai;

class NewApiServices {
  static String clientIdEncoded = utf8.fuse(base64).encode(ai.clientId + ":");
  late Dio _dio;

  NewApiServices() {
    _dio = Dio();
  }

  Future<dynamic> getMyIdentity(String token) async {
    _dio.options.headers["Authorization"] = "bearer " + token;
    return _dio.get(ai.oauthUrlPrefix + "/api/v1/me").then((response) {
      return ProfileIdentity.fromResponse(response);
    }).catchError((onError) {
      throw (onError.toString());
    });
  }

  Future<dynamic> getUserSettings(String token) async {
    _dio.options.headers["Authorization"] = "bearer " + token;
    return _dio.get(ai.oauthUrlPrefix + "/api/v1/me/prefs").then((response) {
      ProfileSettings profileSettings = ProfileSettings();
      profileSettings.setSettingsFromResponse(response);
      return profileSettings;
    }).catchError((onError) {
      throw (onError.toString());
    });
  }

  Future<String> getAccessToken(String code) async {
    _dio.options.headers["Authorization"] = "Basic " + clientIdEncoded;
    _dio.options.headers["Content-type"] = "application/x-www-form-urlencoded";
    var body =
        "grant_type=authorization_code&code=$code&redirect_uri=${ai.redirectUri}";
    return _dio
        .post(ai.accessTokenUrlPrefix + "/api/v1/access_token", data: body)
        .then((response) {
      Map<String, dynamic> newResponse = response.data;
      return newResponse["access_token"] as String;
    }).catchError((onError) {
      throw (onError.toString());
    });
  }

  Future<List<SubReddit>> searchSubReddit(String query, String token) async {
    String limit = "99";
    String sort = "relevance";
    _dio.options.headers["Authorization"] = "bearer " + token;
    _dio.options.contentType = "application/x-www-form-urlencoded";
    var params = "?q=\"$query\"&limit=$limit&sort=$sort";

    return _dio
        .get(ai.oauthUrlPrefix + "/subreddits/search$params")
        .then((response) {
      List<SubReddit> listSubReddit = [];
      List<dynamic> childrens = response.data["data"]["children"];
      for (dynamic child in childrens) {
        listSubReddit.add(SubReddit.fromChildResponse(child));
      }
      return listSubReddit;
    }).catchError((onError) {
      throw (onError.toString());
    });
  }

  Future<PairOption<String, List<Post>>> searchPost(
      String token, String whichType, String params, String subReddit) {
    _dio.options.headers["Authorization"] = "bearer " + token;
    subReddit = subReddit.isNotEmpty ? "/" + subReddit : "";
    print(subReddit);
    print(token);
    return _dio
        .get(ai.oauthUrlPrefix + subReddit + "/$whichType" + params)
        .then((response) {
      List<Post> listPost = [];
      List<dynamic> childrens = response.data["data"]["children"];
      for (dynamic child in childrens) {
        Post newPost = Post();
        newPost.setPostFromChildResponse(child);
        listPost.add(newPost);
      }
      print(listPost.last.postTitle);
      return PairOption(response.data["data"]["after"].toString(), listPost);
    }).catchError((onError) {
      throw (onError.toString());
    });
  }

  Future<void> subscribeSubReddit(
      String token, bool subscribe, String idSubReddit) {
    _dio.options.headers["Authorization"] = "bearer " + token;
    String action = subscribe ? "sub" : "unsub";
    String actionSource = "o";
    String skipInitialDefaults = subscribe ? "true" : "false";
    var params =
        "?action=$action&action_source=$actionSource&skip_initial_defaults=$skipInitialDefaults&sr=$idSubReddit";
    return _dio
        .post(ai.oauthUrlPrefix + "/api/subscribe$params")
        .then((response) {})
        .catchError((onError) {
      throw ("Error Subscribe / Unsubscribe to this SubReddit");
    });
  }

  Future<void> patchSettings(String token, Map<String, dynamic> newSettings) {
    _dio.options.headers["Authorization"] = "bearer " + token;

    var params = jsonEncode(newSettings);
    return _dio
        .patch(ai.oauthUrlPrefix + "/api/v1/me/prefs", data: newSettings)
        .then((response) {})
        .catchError((onError) {
      throw onError;
    });
  }

  Future<List<SubReddit>> searchSubRedditISubscribedTo(String token) {
    _dio.options.headers["Authorization"] = "bearer " + token;
    _dio.options.contentType = "application/x-www-form-urlencoded";

    return _dio
        .get(ai.oauthUrlPrefix + "/subreddits/mine/subscriber")
        .then((response) {
      List<SubReddit> listSubReddit = [];
      List<dynamic> childrens = response.data["data"]["children"];
      for (dynamic child in childrens) {
        listSubReddit.add(SubReddit.fromChildResponse(child));
      }
      return listSubReddit;
    }).catchError((onError) {
      throw (onError.toString());
    });
  }
}
