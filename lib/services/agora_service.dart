import 'package:agora_rtc_engine/rtc_engine.dart';

class AgoraService {
  RtcEngine engine;
  static const APP_ID = 'e19fd95630d243ee869ae0d2072deebe';

  // AGORA_APP_ID:"e19fd95630d243ee869ae0d2072deebe",
  // AGORA_APP_CERTIFICATE: "b31f68e5df7e4e52abfb279961dfe85d"

  AgoraService(){
    initPlatformState();
  }
  Future<void> initPlatformState() async {
    engine = await RtcEngine.create(APP_ID);
    engine.setEnableSpeakerphone(true);

  }

  RtcEngine instance() {
    return engine;
  }
}