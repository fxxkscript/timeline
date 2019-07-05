import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class Share {
  static final Share _instance = new Share._internal();

  Share._internal();

  factory Share() => _instance;

  static const channel = const MethodChannel('com.meizizi.doraemon/door');

  Future<void> timeline(List<String> pics, String text) async {
    try {
      if (pics.isEmpty) {
        await fluwx.share(fluwx.WeChatShareTextModel(text: text));
      } else {
        final int result =
            await channel.invokeMethod('weixin', {'pics': pics, 'text': text});
        debugPrint(result.toString());
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}
