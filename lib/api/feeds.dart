import 'package:wshop/models/feeds.dart';
import 'package:wshop/utils/http_client.dart';

Future<void> getTimeline(context, int cursor, [int pageSize = 10]) async {
  try {
    var response = await HttpClient().post(context, 'feeds/timeline/home',
        {'cursor': cursor, 'pageSize': pageSize});
    print(response);
  } catch (e) {
    print(e);
  }
}

Future<void> publish(context, Feed feed) async {
  try {
    var response = await HttpClient()
        .post(context, 'feeds/timeline/publish', feed.toJson());
    print(feed.toJson());
  } catch (e) {
    print(e);
  }
}
