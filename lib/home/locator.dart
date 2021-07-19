import 'package:oho_works_app/services/agora_service.dart';
import 'package:oho_works_app/services/audio_socket_service.dart';
import 'package:oho_works_app/services/call_email_.dart';
import 'package:oho_works_app/services/deeplinking_service.dart';
import 'package:oho_works_app/services/get_deeplink_url_service.dart';
import 'package:oho_works_app/services/messenger_socket_provider.dart';
import 'package:oho_works_app/services/navigation_service.dart';
import 'package:oho_works_app/services/push_notification_service.dart';
import 'package:oho_works_app/services/share_data_service.dart';
import 'package:oho_works_app/services/socket_service.dart';
import 'package:oho_works_app/services/update_message_status_service.dart';
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => MessengerSocketProvider());
  locator.registerLazySingleton(() => AgoraService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => CallsAndMessagesService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => SocketService());
  locator.registerLazySingleton(() => AudioSocketService());
  locator.registerLazySingleton(() => CreateDeeplink());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => SharedDataService());
  locator.registerLazySingleton(() => EventBus());
  locator.registerSingletonAsync(() async=> await SharedPreferences.getInstance());
  locator.registerLazySingleton(() => UpdateMessageStatusService());

}
