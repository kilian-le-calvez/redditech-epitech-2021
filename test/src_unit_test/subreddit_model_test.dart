import 'package:redditech/model/subreddit_model.dart';
import 'package:test/test.dart';

void subredditModelTest() {
  group('subredditModel', () {
    test('default ctor', () {
      expect(SubReddit().getSubredditInfo(), ["", "", "", "", "", 0, false]);
    });

    test('ctor fromChildResponse', () {
      dynamic child = {
        "data": {
          "display_name_prefixed": "title",
          "name": "id",
          "public_description": "description",
          "icon_img": "img_path",
          "banner_img": "banner_path",
          "subscribers": 10,
          "user_is_subscribed": false,
        },
        "other": "",
      };
      SubReddit subReddit = SubReddit.fromChildResponse(child);
      expect(subReddit.getSubredditInfo(),
          ["title", "id", "description", "img_path", "banner_path", 10, false]);
    });

    test('ctor fromChildResponse', () {
      dynamic child = {
        "ERROR": {
          "display_name_prefixed": "title",
          "name": "id",
          "public_description": "description",
          "icon_img": "img_path",
          "subcribers": 10,
          "user_is_subscribed": false
        }
      };
      SubReddit subReddit = SubReddit.fromChildResponse(child);
      expect(subReddit.getSubredditInfo(), ["", "", "", "", "", 0, false]);
    });
  });
}
