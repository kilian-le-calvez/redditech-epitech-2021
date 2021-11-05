import 'package:dio/dio.dart';

class ProfileIdentity {
  late String profileName;
  late String profilePicturePath;
  late String profileBannerPath;
  late String profileNumberFriends;
  late String profileDescription;
  ProfileIdentity()
      : profileName = "",
        profilePicturePath = "",
        profileBannerPath = "",
        profileNumberFriends = "",
        profileDescription = "";

  List<String> getProfileInfo() {
    return [
      profileName,
      profilePicturePath,
      profileBannerPath,
      profileNumberFriends,
      profileDescription
    ];
  }

  fromString(
      String profileName,
      String profilePicturePath,
      String profileBannerPath,
      String profileNumberFriends,
      String profileDescription) {
    this.profileName = profileName;
    this.profilePicturePath = profilePicturePath;
    this.profileBannerPath = profileBannerPath;
    this.profileNumberFriends = profileNumberFriends;
    this.profileDescription = profileDescription;
  }

  String discardUrlArgs(String url) {
    return url.split("?")[0];
  }

  ProfileIdentity.fromResponse(Response<dynamic> response) {
    Map<String, dynamic> data = response.data;

    profileName = data["name"] ?? "";
    profilePicturePath = discardUrlArgs(data["icon_img"] ?? "");
    profileBannerPath = discardUrlArgs(data["subreddit"]["banner_img"] ?? "");

    profileNumberFriends = (data["num_friends"] ?? "").toString();
    profileDescription =
        (data["subreddit"]["public_description"] ?? "").toString();
  }

  void clear() {
    fromString("", "", "", "", "");
  }
}
