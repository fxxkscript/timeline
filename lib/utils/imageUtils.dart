class ImageUtils {
  static String getRawUrl(String link) {
    return link.replaceAll(RegExp(r'\-tweet_pic_v1'), '');
  }

  static List<String> getRawUrls(List<String> links) {
    return links.map((link) => getRawUrl(link)).toList();
  }

  static String getKey(String link) {
    return link
        .replaceAll(RegExp(r'\-tweet_pic_v1'), '')
        .replaceAll('http://img.ippapp.com/', '')
        .replaceAll('https://img.ippapp.com/', '');
  }
}
