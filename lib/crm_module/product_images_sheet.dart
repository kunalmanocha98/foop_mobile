import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appAttachmentComponent.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/crm_module/select_unit_sheet.dart';
import 'package:oho_works_app/crm_module/set_pricing_sheet.dart';
import 'package:oho_works_app/crm_module/term_and_condition_sheet.dart';
import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/profile_module/pages/empty_widget.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MediaUploadSheet extends StatefulWidget
{
 final int? selectedTab;

  const MediaUploadSheet({Key? key, this.selectedTab}) : super(key: key);

 @override
 MediaUploadSheetState createState() => MediaUploadSheetState(

 );
}


class MediaUploadSheetState extends State<MediaUploadSheet> {
   Function(String value)? onClickCallback;
   SharedPreferences? prefs;
   GlobalKey<appAttachmentsState> attachmentKey = GlobalKey();
  List<MediaDetails> mediaList = [];
  List<dynamic>? countryCodeList = [];
  int? selectedTab;
   MediaUploadSheetState({this.selectedTab});
  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem> countryCodes = [];
    TextStyleElements styleElements = TextStyleElements(context);
    _getCountryCodes() {
      for (int i = 0; i < countryCodeList!.length; i++) {
        countryCodes.add(DropdownMenuItem(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                countryCodeList![i].flagIconUrl??"",
                style: styleElements.bodyText2ThemeScalable(context),
              ),
              Padding(
                padding: const EdgeInsets.only(left:4.0,right: 4.0),
                child: Text(
                  countryCodeList![i].dialCode,
                  style: styleElements.bodyText2ThemeScalable(context),
                ),
              ),
            ],
          ),
          value: countryCodeList![i].dialCode,
        ));
      }
      return countryCodes;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0,left: 16,right: 16,top: 16),
        child: Container(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft:  Radius.circular(20.0),
                  topRight:  Radius.circular(20.0))),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //Center Row contents vertically,

                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Text(
                          AppLocalizations.of(context)!.translate("back"),
                          textAlign: TextAlign.center,
                          style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                        ),
                      ),),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                            AppLocalizations.of(context)!.translate("add_media"),
                            textAlign: TextAlign.center,
                            style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          showModalBottomSheet<void>(
                            context: context,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                            ),

                            isScrollControlled: true,
                            builder: (context) {
                              return TermAndConditionSheet(
                                prefs: prefs,
                                selectedTab:selectedTab,
                                onClickCallback: (value) {

                                },
                              );
                              // return BottomSheetContent();
                            },
                          );
                        },
                        child: InkWell(
                          onTap: (){

                            Navigator.pop(context);
                            showModalBottomSheet<void>(
                              context: context,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                              ),

                              isScrollControlled: true,
                              builder: (context) {
                                return UnitTypeSheet(
                                  prefs: prefs,
                                  onClickCallback: (value) {

                                  },
                                );
                                // return BottomSheetContent();
                              },
                            );
                          },
                          child: Container(
                            child: Text(
                              AppLocalizations.of(context)!.translate("next"),
                              textAlign: TextAlign.center,
                              style: styleElements.subtitle1ThemeScalable(context).copyWith(fontWeight: FontWeight.bold,color: HexColor(AppColors.appMainColor)),
                            ),
                          ),
                        ),
                      ),)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top:8.0,bottom:8.0),
                child: Column(
                  children: [

                    mediaList.isNotEmpty?
                    Center(
                      child: SizedBox(
                        height: 200,
                        child: GridView.count(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            crossAxisCount: 3,
                            childAspectRatio: 0.9,
                            children: mediaList!.map((MediaDetails data) {
                              return     SizedBox(
                                height: 100,
                                width: 100,
                                child: Stack(
                                  children: [

                                    CachedNetworkImage(
                                      height: 100,
                                      width: 100,
                                      imageUrl: Utility().getUrlForImage(data.mediaUrl, RESOLUTION_TYPE.R64, SERVICE_TYPE.POST) ,
                                      fit: BoxFit.cover,
                                    ),
                                    Visibility(
                                      visible:data.mediaType == 'video',
                                      child: Container(
                                        child: Center(
                                            child:Icon(Icons.play_circle_outline_outlined,color:HexColor(AppColors.appMainColor)
                                            )
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: Utility().checkFileMimeType(data.mediaType),
                                      child: Container(
                                        child: Center(
                                            child:Icon(Icons.file_copy_outlined,color:HexColor(AppColors.appMainColor)
                                            )
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                              );
                            }).toList()),
                      ),
                    )
                        :Center(child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomPaginator(context).emptyListWidgetMaker(null),
    )),



                    appAttachments(
                      attachmentKey,
                      hideMedia:true,
                      itemPickedCallBack:(){

                        print("----------------------");
                       setState(() {
                         mediaList= attachmentKey.currentState!.mediaList;
                         print("----------------------"+mediaList.length.toString());
                       });
                      },
                      isMentionVisible: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }
}