import 'package:oho_works_app/models/deeplinking_payload.dart';
import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName,DeepLinkingPayload deepLinkingPayload,BuildContext? context) {
    return navigatorKey.currentState!.pushNamed(routeName,arguments: deepLinkingPayload);
  }
}
