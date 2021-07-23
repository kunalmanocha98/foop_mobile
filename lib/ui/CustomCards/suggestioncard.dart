
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/pages/profile_page.dart';
import 'package:oho_works_app/profile_module/pages/suggestionsPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/follow_unfollow_block_remove_unblock_button.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: must_be_immutable
class SuggestionCard extends StatelessWidget {
  CommonCardData data;
  late TextStyleElements styleElements;
  String? ownerType;
  int? ownerId;
  Null Function()? callbackPicker;
  SuggestionCard({Key? key, required this.data,this.ownerType,this.ownerId,this.callbackPicker}) : super(key: key);
  List<Data> items=[];

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

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return Container(

        padding:EdgeInsets.all(0.0),
        child:   Container(

            margin: const EdgeInsets.only(),
            child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16.0.h,
                                right: 16.h,
                                top: 12.h,
                                bottom: 12.h),
                            child: Text(
                             AppLocalizations.of(context)!.translate("suggestions"),
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
                    Visibility(

                      child: Flexible(
                        child:  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Align(
                              alignment: Alignment.topRight,
                              child:  GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Suggestions(

                                          ),
                                        ));
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.translate('see_more'),
                                  style: styleElements
                                      .subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor))
                                   ,
                                  textAlign: TextAlign.left,
                                )
                              )),
                        ),
                        flex: 1,
                      ),
                    ),
                  ],
                ),
                TricycleListCard(
                  padding:EdgeInsets.only(top: 8,bottom: 4,left: 0,right: 0),
                  margin: EdgeInsets.only(left: 0,right: 0,top: 4,bottom: 4),
                  child: Container(
                    height: 180,
                      child: new ListView.builder(
                          padding: EdgeInsets.all(0.0),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: data.data!.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.all(4),
                              width: 120,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => UserProfileCards(
                                                  userType: data.data![index].suggestedType=="person"?"thirdPerson":data.data![index].suggestedType,
                                                  userId: data.data![index].id,
                                                  callback: () {
                                                    callbackPicker!();
                                                  },
                                                  currentPosition: 1,
                                                  type: null,
                                                )));
                                      },
                                      child: TricycleAvatar(
                                        size: 96,
                                        key: UniqueKey(),
                                        withBorder: true,
                                        resolution_type: RESOLUTION_TYPE.R256,
                                        service_type: SERVICE_TYPE.PERSON,
                                        imageUrl: data.data![index].avatar,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 2.h, bottom: 0.h, left: 8.w, right: 4.w),
                                    child: Text(Utility().getFirstName(data.data![index].title!),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: styleElements.subtitle1ThemeScalable(context),
                                    ),
                                  ),
                                  // Align(
                                  //     alignment: Alignment.topLeft,
                                  //     child: Padding(
                                  //         padding: EdgeInsets.only(
                                  //             top: 0.h, bottom: 4.h, left: 8.w, right: 4.w),
                                  //         child: Text(data.data[index].subtitle??"",
                                  //             overflow: TextOverflow.ellipsis,
                                  //             textAlign: TextAlign.left,
                                  //             maxLines: 1,
                                  //             style: styleElements.bodyText2ThemeScalable(context)))),
                                  Visibility(
                                      visible: true,
                                      child: GenericFollowUnfollowButton(
                                        actionByObjectType: ownerType,
                                        actionByObjectId: ownerId,
                                        isRoundedButton: false,
                                        actionOnObjectType: data.data![index].suggestedType,
                                        actionOnObjectId: data.data![index].id,
                                        engageFlag: (data.data![index].isFollowed!=null?data.data![index].isFollowed:false)!
                                            ? AppLocalizations.of(context)!.translate('following')
                                            : AppLocalizations.of(context)!.translate('follow'),
                                        actionFlag: (data.data![index].isFollowed!=null?data.data![index].isFollowed:false)! ? "U" : "F",
                                        actionDetails: [],
                                        personName: "",
                                        callback: (isCallSuccess) {
                                          callbackPicker!();
                                        },
                                      ))
                                ],
                              ),
                            );
                          })),
                ),
              ],
            )

        ));
  }
}

