import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/ui/postModule/selectedPostListPage.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventPostScreenPage extends StatefulWidget {
  final int? eventId;
  EventPostScreenPage({Key? key,this.eventId}):super(key: key);
  @override
  EventPostScreenPageState createState() => EventPostScreenPageState();
}

class EventPostScreenPageState extends State<EventPostScreenPage> {
  SharedPreferences? prefs = locator<SharedPreferences>();
  GlobalKey<SelectedFeedPageState> postListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child:SelectedFeedListPage(
        key: postListKey,
        appBarTitle: "",
        isOthersPostList: true,
        isFromProfile: true,
        postOwnerTypeId: prefs!.getInt(Strings.userId),
        postOwnerType: prefs!.getString(Strings.ownerType),
        isRoomPost: false,
        isEventPost: true,
        eventId: widget.eventId,
      ),
    );
  }
  void refresh() {
    postListKey.currentState!.refresh();
  }
}
