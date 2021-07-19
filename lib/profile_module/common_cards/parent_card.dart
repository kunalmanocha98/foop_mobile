import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable

// ignore: must_be_immutable
class ParentCard extends StatelessWidget {
  final CommonCardData data;
  BuildContext context;
  List<SubRow> listSubItems = [];
  TextStyleElements styleElements;
  bool isProfile;
  String instituteId;
  Null Function() callbackPicker;
  int id;
  String personType;
  String ownerType;
  int ownerId;

  Size displaySize(BuildContext context) {
    debugPrint('Size = ' + MediaQuery.of(context).size.toString());
    return MediaQuery.of(context).size;
  }

  double displayHeight(BuildContext context) {
    debugPrint('Height = ' + displaySize(context).height.toString());
    return displaySize(context).height;
  }

  double displayWidth(BuildContext context) {
    debugPrint('Width = ' + displaySize(context).width.toString());
    return displaySize(context).width;
  }

  ParentCard({
    Key key,
    @required this.data,
    this.instituteId,
    this.isProfile,
    this.id,
    this.ownerId,
    this.ownerType,
    this.personType,
    this.callbackPicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);
    listSubItems = data.subRow;
    return TricycleListCard(
        child: Column(
      children: <Widget>[
        Visibility(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 12),
                    child: Text(
                      data.title ?? "",
                      style: styleElements
                          .headline6ThemeScalable(context)
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: HexColor(AppColors.appColorBlack85)),
                      textAlign: TextAlign.left,
                    ),
                  )),
              flex: 3,
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.only(
              top: 16, bottom: 16, left: 16, right: 16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              data.textOne ??= "",
              style: styleElements
                  .subtitle2ThemeScalable(context)
                  .copyWith(color: HexColor(AppColors.appColorBlack85)),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        listSubItems.isNotEmpty && listSubItems != null
            ? ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: listSubItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfileCards(
                                userType: int.parse(listSubItems[index].childId) == ownerId
                                    ? "person"
                                    : "thirdPerson",
                                userId: int.parse(listSubItems[index].childId)!= ownerId ?int.parse(listSubItems[index].childId) : null,
                                callback: () {

                                },
                                currentPosition: 1,
                                type: null,
                              )));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        color: HexColor(AppColors.appColorWhite),
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0.h),
                          child: Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserProfileCards(
                                            userType: int.parse(listSubItems[index].childId) == ownerId
                                                ? "person"
                                                : "thirdPerson",
                                            userId: int.parse(listSubItems[index].childId)!= ownerId ?int.parse(listSubItems[index].childId) : null,
                                            callback: () {

                                            },
                                            currentPosition: 1,
                                            type: null,
                                          )));
                                },
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CircleAvatar(
                                      radius: 36,
                                      foregroundColor: HexColor(AppColors.appColorWhite),
                                      backgroundColor: HexColor(AppColors.appColorWhite),
                                      child: ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/appimages/userplaceholder.jpg',
                                          image:
                                              listSubItems[index].urlOne ??
                                                  "",
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            listSubItems[index].textOne ??=
                                                "",
                                            style: styleElements
                                                .subtitle2ThemeScalable(
                                                    context)
                                                .copyWith(
                                                    color: HexColor(AppColors.appColorBlack85)),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Visibility(
                                            child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            listSubItems[index].textThree ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: styleElements
                                                .captionThemeScalable(
                                                    context)
                                                .copyWith(
                                                    color: HexColor(AppColors.appColorBlack35)),
                                            textAlign: TextAlign.left,
                                          ),
                                        )),
                                      ]),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GenericFollowUnfollowButton(
                                  textColor: HexColor(AppColors.appColorWhite),
                                  backGroundColor:
                                      HexColor(AppColors.appMainColor),
                                  actionByObjectType: ownerType,
                                  actionByObjectId: ownerId,
                                  actionOnObjectType: "person",
                                  actionOnObjectId: int.parse(
                                      listSubItems[index].childId),
                                  engageFlag: listSubItems[index].isFollow2
                                      ? AppLocalizations.of(context)
                                          .translate('following')
                                      : AppLocalizations.of(context)
                                          .translate('follow'),
                                  actionFlag: listSubItems[index].isFollow2
                                      ? "U"
                                      : "F",
                                  actionDetails: [],
                                  personName: "",
                                  callback: (isCallSuccess) {
                                    callbackPicker();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
            : Container(
                height: 150,
                width: 200,
                margin: const EdgeInsets.only(bottom: 20, top: 20),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: HexColor(AppColors.appColorWhite),
                ),
                child: CustomPaginator(context).emptyListWidgetMaker(null)),
        Visibility(
            visible: false,
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: () async {
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileCards(
                            type: "kids",
                            currentPosition: 2,
                            userId: id,
                            userType: personType,
                          ),
                        ));
                    if (result != null && result['result'] == "update") {
                      callbackPicker();
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 16, bottom: 16, top: 16),
                    child: Visibility(
                      /*visible: data.isShowMore ??= false,*/
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(AppLocalizations.of(context).translate('see_more'),
                          style:
                              styleElements.subtitle2ThemeScalable(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )),
            ))
      ],
    ));
  }
}
