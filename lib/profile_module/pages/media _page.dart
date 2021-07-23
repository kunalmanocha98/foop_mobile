import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Enums/subcontexttype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/models/media_files.dart';
import 'package:oho_works_app/models/post/postlist.dart';
import 'package:oho_works_app/profile_module/pages/facility_create.dart';
import 'package:oho_works_app/ui/imgevideoFullScreenViewPage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class MediaPage extends StatefulWidget {
  int? userId;
  String? userType;
  String? instituteId;
  int? ownerId;
  String? ownerType;

  MediaPage({Key? key, required this.userId,this.userType, this.ownerId,this.ownerType, this.instituteId})
      : super(key: key);

  @override
  _MediaPage createState() =>
      _MediaPage(instituteId, ownerId, userType, userId);
}

class _MediaPage extends State<MediaPage> {
  String? searchVal;
  String? personName;
  String? userType;
  int? userId;

  bool? isUserExist;
  List<Media> images= [];
  String? instituteId;
  int? ownerId;
  String? ownerType;
  Null Function()? callback;
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  late SharedPreferences prefs;
  late TextStyleElements styleElements;
  int? pageNumber;
  int? totalItems;

  void setSharedPreferences() async {
    refresh();
  }

  Future<void> _setPref() async {
    prefs = await SharedPreferences.getInstance();
    ownerId=prefs.getInt("userId");
    ownerType=prefs.getString("ownerType");
    paginatorGlobalKey.currentState!.changeState(
      listType: ListType.GRID_VIEW,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2,
      ),
    );
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

    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8.0, top: 12),
      decoration: BoxDecoration(
        color: HexColor(AppColors.appColorWhite),
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0)),
      ),
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
                      child: Text(AppLocalizations.of(context)!.translate('media'),
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
                    visible: false,
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
                child:RefreshIndicator(
                  onRefresh: refreshList,
                  child: Paginator.listView(
                      key: paginatorGlobalKey,
                      padding: EdgeInsets.only(top: 16),
                      shrinkWrap: true,
                      scrollPhysics: BouncingScrollPhysics(),
                      pageLoadFuture: getMediaFiles,
                      pageItemsGetter: listItemsGetter,
                      listItemBuilder: listItemBuilder,
                      loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                      errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                      emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                      totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                      pageErrorChecker: CustomPaginator(context).pageErrorChecker),
                ),
              ),)
        ],
      ),
    );
  }
  Future<Null> refreshList() async {
    refresh();
    await new Future.delayed(new Duration(seconds: 2));

    return null;
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
          onProgressCallback: (int value){
            pr.update(progress:value.toDouble());
          },
              mimeType: contentType[1],
              contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        var imageResponse = ImageUpdateResponse.fromJson(value);
        var url = imageResponse.rows!.otherUrls![0].original;
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

  Future<MediaFiles> getMediaFiles(int page) async {
    pageNumber = page;
    prefs = await SharedPreferences.getInstance();
    final body = jsonEncode({
      "owner_type": userType!=null && userType=="institution"?"institution":"person",
      "owner_id":userId!=null? userId:ownerId,
      "searchVal": null,
      "page_size": 5,
      "page_number": page
    });

    var res = await Calls().call(body, context, Config.MEDIA_FILES);

    return MediaFiles.fromJson(res);
  }
  List<Media>? listItemsGetter(MediaFiles ?pageData) {
    totalItems = pageData!.total;
    images.addAll(pageData.rows!);
    return pageData.rows;
  }

  Widget listItemBuilder(value, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        // images=[];
        // var data=Media();
        // data.mediaUrl=value.mediaUrl;
        // data.mediaType=value.mediaType.contains("image")?"image":"video";
        // images.add(data);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ImageVideoFullPage(
              ownerId: ownerId,
              ownerType: ownerType,
              mediaList: images,
              isWithOutData:true,
              isMediaPage: true,
              pageNumber: pageNumber,
              position: index,
              totalItems:totalItems
            )));
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),

        child: Stack(

         children: [
        new Container(
        decoration: new BoxDecoration(
        image: new DecorationImage(
        image: new NetworkImage(
        Config.BASE_URL+ value.mediaThumbnailUrl,
        ),
        fit: BoxFit.cover,
      ),
    ),
    ),


           Visibility(
             visible: value.mediaType.contains("video"),
             child: Align(
                 alignment: Alignment.center,
                 child: Opacity(
                     opacity: 0.4,
                     child: GestureDetector(
                       behavior: HitTestBehavior.translucent,
                         onTap: () {
                             // images=[];
                             // var data=Media();
                             // data.mediaUrl=value.mediaUrl;
                             // data.mediaType=value.mediaType.contains("image")?"image":"video";
                             // images.add(data);
                             Navigator.of(context).push(MaterialPageRoute(
                                 builder: (context) =>ImageVideoFullPage(
                                   ownerId: ownerId,
                                   ownerType: ownerType,
                                   mediaList: images,
                                   isWithOutData:true,
                                   isMediaPage: true,
                                   pageNumber: pageNumber,
                                   position: index,
                                     totalItems:totalItems
                                 )));
                         },
                         child: Container(
                             decoration: BoxDecoration(
                                 color: HexColor(AppColors.appColorBlack),
                                 shape: BoxShape.circle),
                             margin: const EdgeInsets.all(8),
                             child: Container(
                               padding:
                               const EdgeInsets.all(4),
                               child: Icon(Icons.play_circle_outline,
                                   color: HexColor(AppColors.appColorWhite)),
                             )))),
               ),

           )
         ],
        ),
      ),
    );
  }

  _MediaPage(this.instituteId, this.ownerId, this.userType, this.userId);


}
