import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/enums/listtypes.dart';
import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/enums/requestedbytype.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestListingPage extends StatefulWidget {
  @override
  _TestListingPage createState() => _TestListingPage();
}

class _TestListingPage extends State<TestListingPage> {
  List<DropdownMenuItem> personTypes = [];
  List<DropdownMenuItem> requestedByTypes = [];
  List<DropdownMenuItem> listTypes = [];
  final formKey = GlobalKey<FormState>();
  late TextStyleElements styleElements ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => setLists());
  }



  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: OhoAppBar().getCustomAppBar(context,
          appBarTitle: AppLocalizations.of(context)!.translate('test_user_list'),
          onBackButtonPress: (){},
        ),
        body: appListCard(
          child: ListView(
            children: [
              appUserListTile(
                title: 'Kunal Manocha',
                subtitle1: 'Teacher, Humpty Dumpty School',
                imageUrl: 'https://picsum.photos/64/64',
                isFullImageUrl: true,
                isPerson: true,
                showAvatar: true,
              ),
              appUserListTile(
                title: 'Kunal Manocha with very very long name ',
                subtitle1: 'Teacher, Humpty Dumpty School',
                imageUrl: 'https://picsum.photos/64/64',
                isFullImageUrl: true,
                isPerson: true,
                showAvatar: true,
              ),
              appUserListTile(
                title: 'Kunal Manocha with very very long name ',
                subtitle1: 'Teacher, Humpty Dumpty School',
                imageUrl: 'https://picsum.photos/64/64',
                isFullImageUrl: true,
                isVerified: true,
                isPerson: true,
                showAvatar: true,
              ),
              appUserListTile(
                title: 'Kunal Manocha',
                subtitle1: 'Teacher, Humpty Dumpty School with long name and verified also ',
                imageUrl: 'https://picsum.photos/64/64',
                isVerified: true,
                isFullImageUrl: true,
                isPerson: true,
                showAvatar: true,
              ),
              appUserListTile(
                title: 'Kunal Manocha',
                subtitle1: 'Teacher, Humpty Dumpty School with long name and verified also ',
                imageUrl: 'https://picsum.photos/64/64',
                isVerified: true,
                isFullImageUrl: true,
                isPerson: true,
                showAvatar: true,
                isModerator: true,
                showRating: true,
                rating: 4.0,
                superScriptText: 'sunday',
              ),
              appUserListTile(
                title: 'Kunal Manocha',
                subtitle1: 'Teacher, Humpty Dumpty School with long name and verified also ',
                imageUrl: 'https://picsum.photos/64/64',
                isVerified: true,
                isFullImageUrl: true,
                isPerson: true,
                showAvatar: true,
                isModerator: true,
                showRating: true,
                rating: 4.0,
                superScriptText: 'sunday',
                subtitle2: 'public',
              ),
              appUserListTile(
                title: 'Kunal Manocha',
                subtitle1: 'Teacher, Humpty Dumpty School with long name and verified also ',
                imageUrl: 'https://picsum.photos/64/64',
                isVerified: true,
                isFullImageUrl: true,
                isPerson: true,
                showAvatar: true,
                isModerator: true,
                showRating: true,
                rating: 4.0,
                isOnline: true,
                superScriptText: 'sunday',
                subtitle2: 'public',
                showCount: true,
                count: 11,
              ),
              appUserListTile(
                title: 'Kunal Manocha',
                subtitle1: 'Teacher, Humpty Dumpty School with long name and verified also ',
                imageUrl: 'https://picsum.photos/64/64',
                isVerified: true,
                isFullImageUrl: true,
                isPerson: true,
                showAvatar: true,
                isModerator: true,
                showRating: true,
                rating: 4.0,
                isOnline: true,
                superScriptText: 'sunday',
                subtitle2: 'public',
                showCount: true,
                count: 111,
              ),
              appUserListTile(
                title: 'Kunal Manocha',
                subtitle1: 'Teacher, Humpty Dumpty School with long name and verified also ',
                imageUrl: 'https://picsum.photos/64/64',
                isVerified: true,
                isFullImageUrl: true,
                isPerson: true,
                showAvatar: true,
                isModerator: true,
                showRating: true,
                isOnline: true,
                rating: 4.0,
                superScriptText: 'sunday',
                subtitle2: 'public',
                trailingWidget: appTextButton(
                  onPressed: (){},
                  child: Text('follow',style: styleElements.captionThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appMainColor)
                  ),),
                ),
              ),
            ],
          ),
        ),
        // body: SingleChildScrollView(
        //   child: Form(
        //     key: formKey,
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: appElevatedButton(
        //             color: HexColor(AppColors.appColorWhite),
        //             onPressed: _testAlluserListing,
        //             child: Text(AppLocalizations.of(context).translate('all_user_listing'),
        //               style: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
        //             ),
        //             shape:
        //                 StadiumBorder(side: BorderSide(color: HexColor(AppColors.appMainColor))),
        //           ),
        //         ),
        //         Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Text(AppLocalizations.of(context).translate('or'))),
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: DropdownButtonFormField(
        //             value: _selectedPersonType,
        //             decoration: InputDecoration(
        //                 contentPadding: EdgeInsets.only(left: 20)),
        //             hint: Padding(
        //               padding: const EdgeInsets.only(left: 0),
        //               child: Text(
        //                 AppLocalizations.of(context).translate('person_type'),
        //                 style: styleElements.bodyText2ThemeScalable(context),
        //               ),
        //             ),
        //             items: personTypes,
        //             onChanged: (value) {
        //               setState(() {
        //                 _selectedPersonType = value;
        //               });
        //             },
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: DropdownButtonFormField(
        //             value: _selectedRequestedByType,
        //             decoration: InputDecoration(
        //                 contentPadding: EdgeInsets.only(left: 20)),
        //             hint: Padding(
        //               padding: const EdgeInsets.only(left: 0),
        //               child: Text(AppLocalizations.of(context).translate('requested_by_type'),
        //                 style: styleElements.bodyText2ThemeScalable(context),
        //               ),
        //             ),
        //             items: requestedByTypes,
        //             onChanged: (value) {
        //               setState(() {
        //                 _selectedRequestedByType = value;
        //               });
        //             },
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: DropdownButtonFormField(
        //             value: _selectedListType,
        //             decoration: InputDecoration(
        //                 contentPadding: EdgeInsets.only(left: 20)),
        //             hint: Padding(
        //               padding: const EdgeInsets.only(left: 0),
        //               child: Text(AppLocalizations.of(context).translate('list_type'),
        //                 style: styleElements.bodyText2ThemeScalable(context),
        //               ),
        //             ),
        //             items: listTypes,
        //             onChanged: (value) {
        //               setState(() {
        //                 _selectedListType = value;
        //               });
        //             },
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: appElevatedButton(
        //             onPressed: _testListing,
        //             color: HexColor(AppColors.appColorWhite),
        //             child: Text(AppLocalizations.of(context).translate('view_listing'),
        //               style: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),
        //             ),
        //             shape:
        //                 StadiumBorder(side: BorderSide(color: HexColor(AppColors.appMainColor))),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }

  setLists() async {
    setPersonTypes();
    setListTypes();
    setRequestedbyTypes();
    setState(() {});
  }

  void setPersonTypes() {
    for (int i = 0; i < PERSON_TYPE.values.length; i++) {
      personTypes.add(DropdownMenuItem(
        child: Text(
          PERSON_TYPE.values[i].name,
        ),
        value: PERSON_TYPE.values[i].type,
      ));
    }
  }

  void setListTypes() {
    for (int i = 0; i < LIST_TYPES.values.length; i++) {
      listTypes.add(DropdownMenuItem(
        child: Text(
          LIST_TYPES.values[i].name,
        ),
        value: LIST_TYPES.values[i].type,
      ));
    }
  }

  void setRequestedbyTypes() {
    for (int i = 0; i < REQUESTED_BY_TYPE.values.length; i++) {
      requestedByTypes.add(DropdownMenuItem(
        child: Text(
          REQUESTED_BY_TYPE.values[i].name,
        ),
        value: REQUESTED_BY_TYPE.values[i].type,
      ));
    }
  }
}
