import 'package:oho_works_app/components/tricycle_talk_footer_button.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TalkParticipantProfilePage extends StatefulWidget {
  final String? userType;
  final int? userId;
  final TALKFOOTERENUM? firstPerson;
  final TALKFOOTERENUM? secondPerson;
  final Null Function(int ?userId, int? isModerator, String? type)?
      moderatorCallback;
  final Null Function(int? userId, String ?role, String? userType)? updateRole;
  final Null Function(int ? userId, String ?userType)? removeUser;
  final Null Function(int? userId, String? userType)? inviteUser;
  final Null Function(int ?userId, String? userType)? reportUser;
  final Null Function(int? userId, String ?userType)? mute;
  final int? isModerator;
  final int? isSpeakerOn;

  TalkParticipantProfilePage(
      {this.userType,
      this.userId,
      this.firstPerson,
      this.secondPerson,
      this.moderatorCallback,
      this.isModerator,
      this.updateRole,
      this.removeUser,
      this.inviteUser,
      this.reportUser,
      this.isSpeakerOn,
      this.mute});

  @override
  _TalkParticipantListPage createState() => _TalkParticipantListPage(
      userId: userId,
      userType: userType,
      isModerator: isModerator,
      moderatorCallback: moderatorCallback,
      updateRole: updateRole,
      removeUser: removeUser,
      inviteUser: inviteUser,
      reportUser: reportUser,
      isSpeakerOn: isSpeakerOn,
      mute: mute);
}

enum ROLESENUM { listner }

class _TalkParticipantListPage extends State<TalkParticipantProfilePage> {
  String? userType;
  Null Function(int? userId, String? userType)? inviteUser;
  int? userId;
  final int? isModerator;
  var followers = 0;
  var following = 0;
  var roomsCount = 0;
  var postCount = 0;
  Null Function(int? userId, String? userType)? mute;
  Null Function(int? userId, String role, String? userType)? updateRole;
  Null Function(int? userId, int isModerator, String? type)? moderatorCallback;
  final Null Function(int? userId, String? userType)? reportUser;
  CommonCardData? profileData;
  CommonCardData? ratingData;
  Persondata? rows;
  bool hasData = false;
  int? isSpeakerOn;
  late TextStyleElements styleElements;
  Null Function(int? userId, String? userType)? removeUser;

  _TalkParticipantListPage(
      {this.userId,
      this.userType,
      this.moderatorCallback,
      this.isModerator,
      this.updateRole,
      this.removeUser,
      this.inviteUser,
      this.reportUser,
      this.isSpeakerOn,
      this.mute});

  SharedPreferences? prefs = locator<SharedPreferences>();
  bool viewFullProfile = false;
  GlobalKey<UserProfileCardsState> profilepageKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => showSheet());
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: UserProfileCards(
          key: profilepageKey,
          userType: userType,
          userId: userId,
          callback: () {},
          currentPosition: 1,
          isFromAudioConf: !viewFullProfile,
          audioOptionsCallback: () {
            showSheet();
          },
          type: null,
        ),
        // bottomSheet: BottomSheet(
        //   builder: (BuildContext context){
        //     return Container(
        //       color: HexColor(AppColors.appColorWhite),
        //       child: ListView(
        //         shrinkWrap: true,
        //         physics: ClampingScrollPhysics(),
        //         children: getItems(),
        //       ),
        //     );
        //   }, onClosing: () {  },
        // ),
      ),
    );
  }

  showSheet() {
    _scaffoldKey.currentState!.showBottomSheet((BuildContext context) {
      return Container(
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: getItems(),
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        backgroundColor: HexColor(AppColors.appColorWhite));
  }

  List<Widget> getItems() {
    if (widget.firstPerson == TALKFOOTERENUM.moderator &&
        widget.secondPerson == TALKFOOTERENUM.moderator) {
      return [
        _fullProfile,
        _moveToAudience,
        _removeModerator,
        _removeFromNow,
        Visibility(
            visible: isSpeakerOn==1,
            child: muteUser),
        _blockUser,
        _reportDisturbing
      ];
    } else if (widget.firstPerson == TALKFOOTERENUM.moderator &&
        widget.secondPerson == TALKFOOTERENUM.speaker) {
      return [
        _fullProfile,
        _moveToAudience,
        _makeModerator,
        Visibility(
            visible: isSpeakerOn==1,
            child: muteUser),
        _removeFromNow,
        _blockUser,
        _reportDisturbing
      ];
    } else if (widget.firstPerson == TALKFOOTERENUM.moderator &&
        widget.secondPerson == TALKFOOTERENUM.audience) {
      return [_fullProfile, _invitedAsSpeaker];
    } else if (widget.firstPerson == TALKFOOTERENUM.speaker &&
        widget.secondPerson == TALKFOOTERENUM.moderator) {
      return [_fullProfile, _reportDisturbing];
    } else if (widget.firstPerson == TALKFOOTERENUM.speaker &&
        widget.secondPerson == TALKFOOTERENUM.speaker) {
      return [_fullProfile, _reportDisturbing];
    } else if (widget.firstPerson == TALKFOOTERENUM.speaker &&
        widget.secondPerson == TALKFOOTERENUM.audience) {
      return [_fullProfile, _startOnetoOneConvo];
    } else if (widget.firstPerson == TALKFOOTERENUM.audience &&
        widget.secondPerson == TALKFOOTERENUM.moderator) {
      return [_fullProfile, _reportDisturbing];
    } else if (widget.firstPerson == TALKFOOTERENUM.audience &&
        widget.secondPerson == TALKFOOTERENUM.speaker) {
      return [_fullProfile, _reportDisturbing];
    } else if (widget.firstPerson == TALKFOOTERENUM.audience &&
        widget.secondPerson == TALKFOOTERENUM.audience) {
      return [_fullProfile, _startOnetoOneConvo];
    } else {
      return [
        _fullProfile,
        _moveToAudience,
        _removeModerator,
        _removeFromNow,
        _blockUser,
        _reportDisturbing
      ];
    }
  }

  Widget get _fullProfile => ListTile(
      onTap: () {
        setState(() {
          profilepageKey.currentState!.refreshForAudioPage();
        });
      },
      leading: Image.asset(
        'assets/appimages/viewprofile.png',
        width: 24,
        height: 24,
      ),
      title: Text(
        AppLocalizations.of(context)!.translate('view_full_profile'),
        style: styleElements
            .bodyText2ThemeScalable(context)
            .copyWith(color: HexColor(AppColors.appColorBlack85)),
      ));

  Widget get _invitedAsSpeaker => InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          inviteUser!(userId, userType == 'thirdPerson' ? "person" : userType);
        },
        child: ListTile(
            leading: Image.asset(
              'assets/appimages/speaker.png',
              width: 24,
              height: 24,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('invite_speaker'),
              style: styleElements
                  .bodyText2ThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
            )),
      );

  Widget get _moveToAudience => InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          updateRole!(userId, "listener",
              userType == 'thirdPerson' ? "person" : userType);
        },
        child: ListTile(
            leading: Image.asset(
              'assets/appimages/audience.png',
              width: 24,
              height: 24,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('move_to_audience'),
              style: styleElements
                  .bodyText2ThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
            )),
      );

  Widget get _makeModerator => InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          moderatorCallback!(userId, isModerator == 1 ? 0 : 1,
              userType == 'thirdPerson' ? "person" : userType);
        },
        child: ListTile(
            leading: Image.asset(
              'assets/appimages/moderator.png',
              width: 24,
              height: 24,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('make_as_moderator'),
              style: styleElements
                  .bodyText2ThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
            )),
      );

  Widget get _removeModerator => InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);

          moderatorCallback!(userId, isModerator == 1 ? 0 : 1,
              userType == 'thirdPerson' ? "person" : userType);
        },
        child: ListTile(
            leading: Image.asset(
              'assets/appimages/logout.png',
              width: 24,
              height: 24,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('remove_as_moderator'),
              style: styleElements
                  .bodyText2ThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
            )),
      );

  Widget get muteUser => InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          mute!(userId, userType == 'thirdPerson' ? "person" : userType);
        },
        child: ListTile(
            leading: Image.asset(
              'assets/appimages/mute.png',
              width: 24,
              height: 24,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('mute'),
              style: styleElements
                  .bodyText2ThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
            )),
      );

  Widget get _removeFromNow => InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          removeUser!(userId, userType == 'thirdPerson' ? "person" : userType);
        },
        child: ListTile(
            leading: Image.asset(
              'assets/appimages/speaker.png',
              width: 24,
              height: 24,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('remove_for_now'),
              style: styleElements
                  .bodyText2ThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
            )),
      );

  Widget get _blockUser => Visibility(
    visible: false,
    child: ListTile(
        leading: Image.asset(
          'assets/appimages/blockuser.png',
          width: 24,
          height: 24,
        ),
        title: Text(
          AppLocalizations.of(context)!.translate('block_user'),
          style: styleElements
              .bodyText2ThemeScalable(context)
              .copyWith(color: HexColor(AppColors.appColorBlack85)),
        )),
  );

  Widget get _startOnetoOneConvo => ListTile(
      leading: Image.asset(
        'assets/appimages/onetoonetalk.png',
        width: 24,
        height: 24,
      ),
      title: Text(
        AppLocalizations.of(context)!.translate('start_oto'),
        style: styleElements
            .bodyText2ThemeScalable(context)
            .copyWith(color: HexColor(AppColors.appColorBlack85)),
      ));

  Widget get _reportDisturbing => InkWell(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          reportUser!(userId, userType == 'thirdPerson' ? "person" : userType);
        },
        child: ListTile(
            leading: Image.asset(
              'assets/appimages/report_disturbance.png',
              width: 24,
              height: 24,
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('report_disturbing'),
              style: styleElements
                  .bodyText2ThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
            )),
      );

// void followersCountApi(BuildContext context) async {
//   final body = jsonEncode({
//     "object_type": userType == "institution" ? "institution" : "person",
//     "object_id": userId,
//   });
//
//   Calls().call(body, context, Config.FOLLOWERS_COUNT).then((value) async {
//     if (value != null) {
//       var data = FollowersFollowingCountEntity.fromJson(value);
//       if (data != null && data.statusCode == 'S10001') {
//         setState(() {
//           followers = data.rows.followersCount ?? 0;
//           following = data.rows.followingCount ?? 0;
//           roomsCount = data.rows.roomsCount ?? 0;
//           postCount = data.rows.postCount ?? 0;
//         });
//       } else {}
//     } else {}
//   }).catchError((onError) {});
// }
//
// void getPersonalProfile() async {
//   if (prefs.getString("basicData") != null) {
//     Map<String, dynamic> map =
//     json.decode(prefs.getString("basicData") ?? "");
//     rows = Persondata.fromJson(map);
//     followersCountApi(context);
//   }
//   final body = jsonEncode({
//     "institution_id": prefs.getInt(Strings.instituteId),
//     "person_id": userId,
//     "detail_type": userType == "institution" ? "institution" : "user",
//     "owner_id": prefs.getInt(Strings.userId)
//   });
//   Calls().call(body, context, Config.USER_PROFILE).then((value) {
//     var d = BaseResponses.fromJson(value);
//     profileData = d.rows.firstWhere((element) {
//       return element.cardName == 'profileNameCard';
//     });
//     ratingData = d.rows.firstWhere((element) {
//       return element.cardName == 'RatingAndReviewCard';
//     });
//     setState(() {
//       hasData = true;
//     });
//   });
// }

}
