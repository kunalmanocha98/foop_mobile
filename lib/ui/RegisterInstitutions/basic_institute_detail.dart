import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:GlobalUploadFilePkg/Enums/contexttype.dart';
import 'package:GlobalUploadFilePkg/Enums/ownertype.dart';
import 'package:GlobalUploadFilePkg/Files/GlobalUploadFilePkg.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/camera_module/camera_page.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/business_response_detail.dart';
import 'package:oho_works_app/models/imageuploadrequestandresponse.dart';
import 'package:oho_works_app/models/post/keywordsList.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/imagepickerAndCropper.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/disctionarylist.dart';
import 'package:oho_works_app/models/drop_down_global.dart';
import 'package:oho_works_app/models/others_name.dart';
import 'package:oho_works_app/models/post/keywordsList.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/institutePhotoPage.dart';
import 'package:oho_works_app/ui/camera_module/photo_preview_screen.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain.dart';
import 'models/basicInstituteData.dart';
import 'models/basic_response.dart';

class BasicInstituteDetails extends StatefulWidget {

 final BusinessData? data;
 final bool isEdit;
final Function? refreshCallback;
  const BasicInstituteDetails({Key? key, this.data,this.isEdit=false,this.refreshCallback}) : super(key: key);
  @override
  _BasicInstituteDetails createState() => new _BasicInstituteDetails();
}

class _BasicInstituteDetails extends State<BasicInstituteDetails>
    with SingleTickerProviderStateMixin {
  String? facebookId;
  String? googleSignInId;
  String? userName;
  String? imageUrl="";
  var range = <String>[];
  var rangeStudent = <String>[];
  late BasicData basicData;
  var instituteTypelist = <String?>[];
  var instCategory = <String?>[];
  var employeeRangeList = <String?>[];
  var employeeRange=["1-10","10-50","50-500","500-10000"];
  bool isTermAndConditionAccepted = false;
  String email = "";
  bool isGoogleOrFacebookDataReceived = false;
  double startPos = -1.0;
  double endPos = 1.0;
  Curve curve = Curves.elasticOut;
  final emailController = TextEditingController();
  final otherName = TextEditingController();
  final instituteNameC = TextEditingController();
  final username = TextEditingController();
  final passwordTextController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final genderController = TextEditingController();
  final descriptionController = TextEditingController();
  late BuildContext context;
  late TextStyleElements styleElements;

  late TextStyleElements tsE;
  String? selectInstCategory;
  String? selectInstType;
  String? selectStRange;
  String? employeeRanget;
  int? selectedEpoch;
  var cat;
  var type;
  var mapIntType = HashMap<String?, String?>();
  var mapCategory = HashMap<String?, String?>();
  late SharedPreferences prefs;
  bool? isSelect1=false;
  bool? isSelect2=false;
  TextEditingController typeAheadControllerHashTag =TextEditingController();
  List<String> _listOfHashTags = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) =>
    {
      setPrefs(),
      getInstituteType(),
        getRelationType(),
    getEditData()



    });
  }

  String quotesCharacterLength = "0";
  setPrefs() async {
    prefs = await SharedPreferences.getInstance();

  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    styleElements = TextStyleElements(context);

    List<DropdownMenuItem> instituteType = [];
    List<DropdownMenuItem> relationType = [];
    List<DropdownMenuItem> empList = [];

    _getInstituteType() {
      for (int i = 0; i < instituteTypelist.length; i++) {
        instituteType.add(DropdownMenuItem(
          child: Text(
            instituteTypelist[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: instituteTypelist[i],
        ));
      }
      return instituteType;
    }


    _getEmployeeRange() {
      for (int i = 0; i < employeeRange.length; i++) {
        empList.add(DropdownMenuItem(
          child: Text(
            employeeRange[i],
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: employeeRange[i],
        ));
      }
      return empList;
    }

    _getRelationtype() {
      for (int i = 0; i < instCategory.length; i++) {
        relationType.add(DropdownMenuItem(
          child: Text(
            instCategory[i]!,
            style: styleElements.bodyText2ThemeScalable(context),
          ),
          value: instCategory[i],
        ));
      }
      return relationType;
    }

    final description = TextField(
      controller: descriptionController,
      textCapitalization: TextCapitalization.words,
      keyboardType: TextInputType.name,

      maxLines: null,
      onChanged: (text) {
        setState(() {
          quotesCharacterLength = text.length.toString();
        });
      },
      inputFormatters: [
        new LengthLimitingTextInputFormatter(300),
      ],
      style: styleElements
          .subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color: HexColor(AppColors.appColorBlack35)),
          hintText: ""),
    );
    tsE = TextStyleElements(context);

    final instituteName = TextField(
      obscureText: false,
      controller: instituteNameC,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,

      style: tsE.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),

      scrollPadding: EdgeInsets.all(20.0.w),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 20.0.w, 15.0.h),
          hintText: AppLocalizations.of(context)!.translate('name_of_entity'),
          hintStyle: tsE.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)).copyWith(color: HexColor(AppColors.appColorBlack65)),

          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 0.0.h,
            ),
          )),
    );


    final otherNameIn = Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Column(
          children: [
            Visibility(
                visible: _listOfHashTags.length>0,
                child: Container(
                  height: 50,
                  padding: EdgeInsets.only(top: 8,bottom: 8,left:8 ,right: 8),
                  alignment: Alignment.centerLeft,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _listOfHashTags.length,
                    padding: EdgeInsets.only(left: 8,right: 8),
                    itemBuilder: (BuildContext context, int index) {
                      return Flexible(
                        child: Chip(
                          label: Text(_listOfHashTags[index]),
                          padding: EdgeInsets.all(8),
                          onDeleted: (){
                            setState(() {
                              _listOfHashTags.removeAt(index);
                            });
                          },
                        ),
                      );
                    },),
                )
            ),
            TypeAheadField(
              suggestionsCallback: (String pattern) async{
                if(pattern.isNotEmpty) {
                  KeywordListRequest payload = KeywordListRequest();
                  payload.searchVal = pattern;
                  payload.pageSize = 20;
                  payload.pageNumber = 1;
                  var res = await Calls().call(
                      jsonEncode(payload), context, Config.OTHERS_NAME_SCHOOL);
                  if(OthersName
                      .fromJson(res)
                      .rows!.length>0) {
                    return OthersName
                        .fromJson(res)
                        .rows!;
                  }else{
                    return [];
                  }
                }else{
                  return [];
                }
              } ,
              itemBuilder: ( context,  itemData) {
                itemData as String;
                return ListTile(
                  title: Text(AppLocalizations.of(context)!.translate('hash')+itemData, style: styleElements.subtitle1ThemeScalable(context),),
                );
              },
              onSuggestionSelected: ( suggestion) {
                suggestion as String;
                typeAheadControllerHashTag.text ="";
                setState(() {
                  _listOfHashTags.add(suggestion);
                });
                // widget.hashTagCallback(suggestion.display);
              },
              direction: AxisDirection.up,
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                onSubmitted: (value){
                  typeAheadControllerHashTag.text ="";
                  setState(() {
                    _listOfHashTags.add(value);
                  });
                  // widget.hashTagCallback(value);
                },
                style: styleElements.subtitle1ThemeScalable(context).copyWith(
                    color: HexColor(AppColors.appColorBlack65)
                ),
                controller: typeAheadControllerHashTag,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("",style: styleElements.headline6ThemeScalable(context),),
                  ),
                  contentPadding: EdgeInsets.only(top:16,left: 16,right: 16),
                  hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
                  hintText: AppLocalizations.of(context)!.translate('other_name'),
                ),
              ),
            ),
          ],
        )
    );
    final institute = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectInstType ?? AppLocalizations.of(context)!.translate("entity_type"),
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getInstituteType(),
      onChanged: (value) {

        setState(() {


          selectInstType = value;
        });
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
    final employeeRanges = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          employeeRanget ?? AppLocalizations.of(context)!.translate("entity_type_employees"),
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getEmployeeRange(),
      onChanged: (value) {
        setState(() {
          employeeRanget = value;
        });
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );

    final category = DropdownButtonFormField<dynamic>(
      value: null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0.w, 15.0.h, 2.0.w, 15.0.h)),
      hint: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Text(
          selectInstCategory ?? AppLocalizations.of(context)!.translate("entity_category"),
          style: styleElements.bodyText2ThemeScalable(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      items: _getRelationtype(),
      onChanged: (value) {

        setState(() {
          selectInstCategory = value;
        });
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
    

    return new WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
          child: Scaffold(
               resizeToAvoidBottomInset: false,
              appBar: appAppBar().getCustomAppBar(
                context,
                actions: [
                  InkWell(
                    onTap:(){
                     submit(context);
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(AppLocalizations.of(context)!.translate('next'), style:styleElements.subtitle2ThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),),

                    )),
                ],
                appBarTitle:AppLocalizations.of(context)!.translate('reg_bus'),
                onBackButtonPress: () {
                  Navigator.pop(context);
                },
              ),
              body:
                Stack(
                  children: [
                    SingleChildScrollView(
                      child: Visibility(
                          visible: !isGoogleOrFacebookDataReceived,
                          child: appCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 16.h),
                                      child: Text(AppLocalizations.of(context)!.translate('basic'),    style: tsE.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),),
                                    )),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: (){

                                      },
                                      child: Padding(
                                        padding:EdgeInsets.only( left: 12, right: 12),
                                        child:    GestureDetector(
                                          onTap: () async {
                                            imagePicker("gallery");
                                          },
                                          child:  Stack(
                                           children:[

                                            Container(
                                            width: 68,
                                            height: 68,
                                            decoration: BoxDecoration(
                                                color: HexColor(AppColors.appColorBlack10),
                                                borderRadius: BorderRadius.circular(8),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,

                                                    image:CachedNetworkImageProvider(
                                                      Utility().getUrlForImage(
                                                          imageUrl,
                                                          RESOLUTION_TYPE.R64,
                                                          SERVICE_TYPE.INSTITUTION),
                                                    )

                                                )
                                            ),

                                          ),
                                             Visibility(
                                               visible: imageUrl==null ||imageUrl!.isEmpty,
                                               child: Container(
                                                 width: 68,
                                                 height: 68,
                                                 child: Center(
                                                   child: Icon(Icons.camera_alt_outlined),
                                                 ),
                                               ),
                                             )
                                             ]
                                          )
                                        ),
                                        ),
                                      ),

                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(right:16),
                                        child: Text("Upload Photo"),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: instituteName,
                                    )),

                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: category),
                                ),


                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: institute),
                                ),


                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8.w, right: 8.w, bottom: 8.h),
                                      child: employeeRanges),
                                ),



                                Container(
                                  margin: EdgeInsets.only(
                                      left: 16.w, right: 8.w, bottom: 8.h),
                                  child: Text("About your business"),
                                ),
                                Container(
                                    height: 150,
                                    margin: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: HexColor(AppColors.appColorGrey500),
                                        ),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                    child: description),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 4.0),
                                    child: Text(
                                      quotesCharacterLength + "/300",
                                      style: styleElements
                                          .captionThemeScalable(context),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          )),
                    ),

                  ],
                
              ))),
    );
  }
  void imagePicker(String type) async {
    File? pickedFile;
    var pr = ToastBuilder().setProgressDialogWithPercent(context,'Uploading Image...');

    if(type=="gallery"){
      pickedFile = await ImagePickerAndCropperUtil().pickImage(context);
      print("#####PATH###  "+pickedFile!.path);
    }else{
      final cameras = await availableCameras();
      var reult = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => Camera(cameras: cameras,type: "camera",)));
      File p = File(reult["result"]);
      pickedFile = await ImagePickerAndCropperUtil().cropFileMulti(context, p);
      print(reult["result"]+"pppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppppp");
    }

    if (pickedFile != null) {
      await pr.show();
      var contentType = ImagePickerAndCropperUtil().getMimeandContentType(
          pickedFile.path);
      await UploadFile(
          baseUrl: Config.BASE_URL,
          context: context,
          token: prefs.getString("token"),
          contextId: '',
          contextType: CONTEXTTYPE_ENUM.FEED.type,
          ownerId: prefs.getInt(Strings.userId).toString(),
          ownerType: OWNERTYPE_ENUM.PERSON.type,
          file: pickedFile,
          subContextId: "",
          subContextType: "",
          onProgressCallback: (int value){
            pr.update(progress:value.toDouble());
          },
          mimeType: contentType[1],
          contentType: contentType[0])
          .uploadFile()
          .then((value) async {
        print(value);
        var imageResponse = ImageUpdateResponse.fromJson(value);
        print (jsonEncode(imageResponse));
        if(imageResponse.statusCode == Strings.success_code) {
       setState(() {
         imageUrl=imageResponse.rows!.fileUrl;
       });
          await pr.hide();
        }else{
          await pr.hide();
          ToastBuilder().showToast(imageResponse.message!, context, HexColor(AppColors.information));
        }
      }).catchError((onError) async {
        await pr.hide();
        print(onError.toString());
        ToastBuilder().showToast(AppLocalizations.of(context)!.translate('some_error_occurred'), context, HexColor(AppColors.information));
      });
    }else{
      await pr.hide();
      ToastBuilder().showToast(AppLocalizations.of(context)!.translate('corrupted_file_error'), context, HexColor(AppColors.information));

    }
  }
  // ignore: missing_return
  Future<bool> _onBackPressed() {
Navigator.pop(context);
    return new Future(() => false);
  }

  void submit(BuildContext ctx) async {

    prefs = await SharedPreferences.getInstance();
    BasicData basicData = new BasicData();
    basicData.name=instituteNameC.text.toString();
    basicData.description=descriptionController.text.toString();
    basicData.inst_cat_code="";
    basicData.entity_type_code="type";
    basicData.listOfNames=_listOfHashTags;
    prefs.setString("instName", instituteNameC.text.toString());
    print(jsonEncode(basicData));

    if (instituteNameC.text.trim().isNotEmpty) {
      if (selectInstType !=null) {
        if (selectInstCategory != null) {
          {
            {
              {

                if(employeeRanget!=null )
                  {


                    mapCategory.forEach((key, value) {
                      if(key==selectInstCategory)
                        cat=value;

                    });
                    mapIntType.forEach((key, value) {
                      if(key==selectInstType)
                        type=value;

                    });
                    prefs = await SharedPreferences.getInstance();
                    BasicData basicData = new BasicData();
                    basicData.name=instituteNameC.text.toString();
                    basicData.description=descriptionController.text.toString();
                    basicData.inst_cat_code=cat;
                    basicData.entity_type_code=type;
                    basicData.employeeRange=employeeRanget;

                    if(widget.isEdit)
                      basicData.businessId=widget.data!.id;
                    basicData.listOfNames=_listOfHashTags;
                    prefs.setString("instName", instituteNameC.text.toString());
                    print(jsonEncode(basicData));

                    if (imageUrl != null) {
                      basicData.profile_image = imageUrl;
                    }
                    final body = jsonEncode(basicData);
                    Calls()
                        .call(body, context,widget.isEdit?Config.BASIC_BUSINESS_EDIT: Config.BASIC_INSTITUTE_REGISTER)
                        .then((value) async {
                      if (value != null) {

                        var resposne = BasicDataResponse.fromJson(value);
                        if (resposne.statusCode == Strings.success_code) {


                          if(widget.refreshCallback!=null)
                            widget.refreshCallback!();
                          if(!widget.isEdit){
                            prefs.setString(Strings.registeredInstituteName, basicData.name??"");
                            prefs.setString(Strings.registeredInstituteImage, imageUrl??"");
                            prefs.setInt("createdSchoolId", resposne.rows!.institutionId!);

                            prefs.setString("create_entity", "Domain");

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DomainPage(
                                      callBack:(){
                                        Navigator.pop(context);

                                      },


                                      instId:resposne.rows!.institutionId!,isEdit:widget.isEdit),
                                ));
                          }
                          else
                            {


                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DomainPage(

                                      refreshCallback: widget.refreshCallback,
                                        callBack:(){


                                          Navigator.pop(context);

                                        },

data:widget.data,
                                        instId:widget.data!.id,isEdit:widget.isEdit),
                                  ));
                            }

                        }
                      }
                    }).catchError((onError) async {

                      print(onError.toString());

                    });


                  }
                else
                  ToastBuilder().showToast(
                      AppLocalizations.of(context)!.translate("employee_number"),
                      context,
                      HexColor(AppColors.information));


              }
            }
          }
        }
        else {
          ToastBuilder().showToast(
              AppLocalizations.of(context)!.translate("company_category"),
              context,
              HexColor(AppColors.information));
        }
      } else
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("company_type"),
            context,
            HexColor(AppColors.information));
    }
    else
      ToastBuilder().showToast(
    AppLocalizations.of(context)!.translate("company_req"), context, HexColor(AppColors.information));
  }




  void getEditData()
  {
    if(widget.data!=null)
      {
        if(widget.data!.profile_image!=null)
          imageUrl=widget.data!.profile_image!;

        if(widget.data!.name!=null)
          instituteNameC.text=widget.data!.name!;

        if(widget.data!.businessType!=null) {
          type=widget.data!.businessType!;
        selectInstType = widget.data!.businessType!;
      }

      if(widget.data!.businessCategory!=null) {
        cat=widget.data!.businessCategory!;
        selectInstCategory = widget.data!.businessCategory!;
      }

        if(widget.data!.noOfEmployees!=null) {

          employeeRanget = widget.data!.noOfEmployees!;
        }

      if(widget.data!.description!=null)
          descriptionController.text=widget.data!.description!;
      }
  }
  void getInstituteType() async {
    final body = jsonEncode({"type":"BUSCAT"});
    Calls().call(body, context, Config.DICTIONARYLIST).then((value) async {
      if (value != null) {
        var data = DictionaryListResponse.fromJson(value);

        for (var item in data.rows!) {
          instituteTypelist.add(item.description);
          mapIntType.putIfAbsent(item.description,() =>item.code);
        }
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }

  void getRelationType() async {
    final body = jsonEncode({"type":"BUSTYPE"} );
    Calls().call(body, context, Config.DICTIONARYLIST).then((value) async {
      if (value != null) {
        var data = DictionaryListResponse.fromJson(value);
        for (var item in data.rows!) {
          instCategory.add(item.description);
          employeeRangeList.add(item.description);
          mapCategory.putIfAbsent(item.description,() =>item.code);
        }
        setState(() {});
      }
    }).catchError((onError) {
      ToastBuilder().showToast(
          onError.toString(), context, HexColor(AppColors.information));
    });
  }
}
