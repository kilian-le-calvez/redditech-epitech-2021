import 'package:dio/dio.dart';
import 'package:redditech/model/profile_indentity_model.dart';
import 'package:test/test.dart';

void profileIdentityModelTest() {
  group('profileIdentityModel', () {
    test('default ctor', () {
      final identity = ProfileIdentity();

      expect(identity.getProfileInfo(), ["", "", "", "", ""]);
    });

    test('fromString', () {
      final identity = ProfileIdentity();

      identity.fromString("profileName", "profilePicturePath",
          "profileBannerPath", "profileNumberFriends", "profileDescription");

      expect(identity.getProfileInfo(), [
        "profileName",
        "profilePicturePath",
        "profileBannerPath",
        "profileNumberFriends",
        "profileDescription"
      ]);
    });

    test('discardUrlArgs', () {
      expect(ProfileIdentity().discardUrlArgs("url?args"), "url");
      expect(ProfileIdentity().discardUrlArgs("url"), "url");
      expect(ProfileIdentity().discardUrlArgs(""), "");
    });

    test('ctor fromResponse', () {
      RequestOptions requestOptions = RequestOptions(path: "path");
      Response<dynamic> response = Response(requestOptions: requestOptions);

      response.data = {
        "name": "kilian",
        "icon_img": "image_path",
        "num_friends": "10",
        "subreddit": {
          "banner_img": "banner_path",
          "public_description": "hello",
        }
      };

      ProfileIdentity identity = ProfileIdentity.fromResponse(response);
      expect(identity.getProfileInfo(),
          ["kilian", "image_path", "banner_path", "10", "hello"]);
    });
    test('ctor fromResponse (with BAD response)', () {
      RequestOptions requestOptions = RequestOptions(path: "path");
      Response<dynamic> response = Response(requestOptions: requestOptions);

      response.data = {
        "name": true,
        "icon_img": "",
        "num_friends": "10",
        "subredditS": {
          "banner_img": 8,
          "public_description": "hello haha",
        }
      };

      ProfileIdentity identity = ProfileIdentity.fromResponse(response);
      expect(identity.getProfileInfo(), ["", "", "10", "", ""]);
    });

    test('clear function', () {
      ProfileIdentity identity = ProfileIdentity();

      identity.fromString("a", "b", "c", "d", "e");
      identity.clear();
      expect(identity.getProfileInfo(), ["", "", "", "", ""]);
    });
  });
}
