class BaseUrls{
/// Change the value of isTest to true for Test server pointer
/// isTest to false for Production server Pointer
  static bool get isTest =>  true;

  static const String testUrl ="https://test.tricycle.group";
  static const String productionUrl ="https://www.tricycle.life";

  static const String testUrl_without_http = "test.tricycle.group";
  static const String productionUrl_without_http = "www.tricycle.life";

  static const String testUrl_messenger = "https://messenger.tricycle.group";
  static const String productionUrl_messenger = "https://messenger.tricycle.life";

  static const String testUrl_audio = "https://audio.tricycle.group";
  static const String productionUrl_audio = "https://audio.tricycle.life";
  static const String nexge = "https://conf-signalling.nexge.com";
  static String get BASE_URL => isTest? testUrl: productionUrl;
  static String get BASE_URL_WITHOUT_HTTP=> isTest? testUrl_without_http :productionUrl_without_http;
  static String get BASE_URL_MESSENGER => isTest? testUrl_messenger: productionUrl_messenger;
  static String get BASE_URL_AUDIO => isTest? testUrl_audio: productionUrl_audio;

  static String get NEXGE_BASE_URL=>nexge;

}