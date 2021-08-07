import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Enums/subcontexttype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/profile_module/pages/facility_create.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: must_be_immutable
class ImagesSeeMore extends StatefulWidget {
  String? type;
  String? userType;
  List<StatelessWidget> listCardsAbout = [];
  TextStyleElements? styleElements;
  BuildContext? context;
  String? instituteId;
  int? ownerId;
  bool? isUserExist;

  List<CommonCardData> listCardData = [];
  SharedPreferences? prefs;

  ImagesSeeMore(
      {Key? key,
      required this.type,
      this.isUserExist,
      this.ownerId,
      this.instituteId})
      : super(key: key);

  @override
  _ImagesSeeMore createState() =>
      _ImagesSeeMore(instituteId, ownerId, type, isUserExist);
}

class _ImagesSeeMore extends State<ImagesSeeMore> {
  String? searchVal;
  String? personName;
  String? type;
  int? id;
  bool? isUserExist;

  String? instituteId;
  int? ownerId;
  String? ownerType;
  Null Function()? callback;
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;

  void setSharedPreferences() async {
    refresh();
  }

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    if (paginatorGlobalKey.currentState != null) {
      paginatorGlobalKey.currentState!.changeState(
        listType: ListType.GRID_VIEW,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 2,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _setPref();
  }

  void onsearchValueChanged(String text) {
    // print(text);
    searchVal = text;
    refresh();
  }

  refresh() {
    paginatorGlobalKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return appListCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 16.0.h,
                        right: 16.h,
                        top: 12.h,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("campus_facilities"),
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
              Flexible(
                child: Visibility(
                    visible:isUserExist!=null&& isUserExist!,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          _addPhoto();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: HexColor(AppColors.appColorGrey500),
                            size: 25,
                          ),
                        ))),
                flex: 1,
              ),
            ],
          ),
          Flexible(
              child: Container(
            margin:
                const EdgeInsets.only(bottom: 2, top: 16, left: 8, right: 8),
            child: Paginator.listView(
                key: paginatorGlobalKey,
                padding: EdgeInsets.only(top: 16),
                scrollPhysics: NeverScrollableScrollPhysics(),
                pageLoadFuture: getPhotos,
                pageItemsGetter: CustomPaginator(context).listItemsGetterPhotos,
                listItemBuilder: listItemBuilder,
                loadingWidgetBuilder:
                    CustomPaginator(context).loadingWidgetMaker,
                errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                emptyListWidgetBuilder:
                    CustomPaginator(context).emptyListWidgetMaker,
                totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                pageErrorChecker: CustomPaginator(context).pageErrorChecker),
          ))
        ],
      ),
    );
  }

  _addPhoto() async {
    var pr =ToastBuilder().setProgressDialogWithPercent(context,'Uploading Image...');
    File pickedFile = await (ImagePickerAndCropperUtil().pickImage(context) as FutureOr<File>);
    var croppedFile =
        await ImagePickerAndCropperUtil().cropFile(context, pickedFile);
    if (croppedFile != null) {
      await pr.show();
      var contentType =
          ImagePickerAndCropperUtil().getMimeandContentType(croppedFile.path);
      await UploadFile(
              baseUrl: Config.BASE_URL,
              context: context,
              token: prefs.getString("token"),
              contextId: instituteId.toString(),
              contextType: CONTEXTTYPE_ENUM.PROFILE.type,
              subContextType: SUBCONTEXTTYPE_ENUM.FACILITIES.type,
              ownerId: prefs.getInt("userId").toString(),
              ownerType: OWNERTYPE_ENUM.PERSON.type,
              file: croppedFile,
              subContextId: "",
              mimeType: contentType[1],
          onProgressCallback: (int value){
            pr.update(progress:value.toDouble());
          },
              contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        var url = imageResponse.rows!.fileUrl;
        print(url);
        await pr.hide();
        var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateFacilities(
                url: url,
                id: instituteId.toString(),
              ),
            ));
        if (result != null && result['result'] != null) {
          refresh();
        }
      }).catchError((onError) async {
        await pr.hide();
        print(onError.toString());
      });
    }
  }

  Future<BaseResponses> getPhotos(int page) async {
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "person_id": null,
      "type": type == "institution" ? "institution" : "person",
      "institution_id": instituteId,
      "page_number": page,
      "given_by_id": prefs.getInt("userId"),
      "page_size": 4
    });

    var res = await Calls()
        .call(body, context, Config.CAMPUS_FACILITIES_SEE_MORE);

    return BaseResponses.fromJson(res);
  }

  Widget listItemBuilder(value, int index) {
    return Container(
        padding: const EdgeInsets.all(4.0),
        child: CachedNetworkImage(
          imageUrl:Config.BASE_URL+ value.textOne,
          placeholder: (context, url) => Center(
              child: Image.asset(
            'assets/appimages/image_place.png',
          )),
          fit: BoxFit.fill,
        ));
  }

  _ImagesSeeMore(this.instituteId, this.ownerId, this.type, this.isUserExist);
}
