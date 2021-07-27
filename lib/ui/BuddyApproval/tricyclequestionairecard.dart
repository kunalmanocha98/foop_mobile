import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/appHighlightSpan.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/enums/buddy_question_type.dart';
import 'package:oho_works_app/enums/paginatorEnums.dart';
import 'package:oho_works_app/models/buddyApprovalModels/buddyListModels.dart';
import 'package:oho_works_app/models/buddyApprovalModels/questionnaire_models.dart';
import 'package:oho_works_app/models/buddyApprovalModels/updateRequest.dart';
import 'package:oho_works_app/models/buddyApprovalModels/verifymodels.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/confirm_details_institute.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/models/basic_refral_data.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/models/scratch_card_response.dart';
import 'package:oho_works_app/ui/RegisterInstitutions/models/scratch_data.dart';
import 'package:oho_works_app/ui/dialogs/approvalwarningDialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/scrach_card_dialogue.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class appQuestionnaireCard extends StatefulWidget{
  final RequestListItem? data;
  final Function(bool?)? callback;
  appQuestionnaireCard({this.data,this.callback});
  @override
  appQuestionnaireCardState createState()=> appQuestionnaireCardState(data: data,callback: callback);
}
class appQuestionnaireCardState extends State<appQuestionnaireCard>{
  late TextStyleElements styleElements;
  RequestListItem? data;
  Function(bool?)? callback;
  appQuestionnaireCardState({this.data,this.callback});
  SharedPreferences? prefs;
  late QuestionnaireListResponse questionsData;
  QuestionsItem? currentQuestion;
  int currentQuestionIndex = 0;
  int selectedIndex =0;
  String? selectedValue;
  bool questionnaireCompleted = false;
  bool? isChecked= false;
  bool isVerifying = false;
  bool isAnyWrongAnswerSubmitted=false;
  String? username="";
  String? role="";
  String? className="";
  String? institutionName="";
  VerifyResponseRow? verifyResponse;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();

  PAGINATOR_ENUMS paginatorEnum = PAGINATOR_ENUMS.LOADING;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => getQuestions());
  }

  void getQuestions() async {
    prefs ??=await SharedPreferences.getInstance();
    QuestionnaireListRequest payload = QuestionnaireListRequest();
    payload.approvedPersonId = data!.personId;
    payload.approvedPersonInstitutionId =data!.institutionId;
    Calls().call(jsonEncode(payload), context, Config.QUESTIONNAIRE_LIST).then((value){
      var res = QuestionnaireListResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
        setState(() {
          questionsData = res;
          paginatorEnum = PAGINATOR_ENUMS.SUCCESS;
          currentQuestion = res.rows![0];
        });
      }else if(res.statusCode == "E100002"){
        ToastBuilder().showToast(res.message!, context, HexColor(AppColors.information));
        setState(() {
          paginatorEnum = PAGINATOR_ENUMS.EMPTY;
        });
      }else{
        setState(() {
          paginatorEnum = PAGINATOR_ENUMS.EMPTY;
        });
      }
    }).catchError((onError){
      print(onError);
      setState(() {
        paginatorEnum = PAGINATOR_ENUMS.ERROR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
   return getContent();
  }
  Widget get acceptBody {
    return appCard(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left:0,right:8),
            leading: Checkbox(
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value;
                });
              },
              value: isChecked,
            ),
            title: RichText(
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              text: TextSpan(
              children: [
                TextSpan(
                  text: 'I confirm that I know ',
                  style: styleElements.subtitle2ThemeScalable(context)
                ),
                TextSpan(
                    text: username,
                    style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)
                ),
                TextSpan(
                    text: ' as a ',
                    style: styleElements.subtitle2ThemeScalable(context)
                ),
                TextSpan(
                    text: role,
                    style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)
                ),
                institutionName!.isNotEmpty?TextSpan(
                    text: ' in ',
                    style: styleElements.subtitle2ThemeScalable(context)
                ):WidgetSpan(child: Container()),
                institutionName!.isNotEmpty?TextSpan(
                    text: institutionName,
                    style: styleElements.subtitle2ThemeScalable(context).copyWith(fontWeight: FontWeight.bold)
                ):WidgetSpan(child: Container()),
              ]
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(right:16.0,top:8),
            child: Row(
              children: [
                Spacer(),
                appTextButton(
                  onPressed: (){
                    RequestUpdateRequestModel payload = RequestUpdateRequestModel();
                    payload.institutionUserId = data!.institutionUserId;
                    payload.institutionId = data!.institutionId;
                    payload.assignmentStatus = "A";
                    Calls().call(jsonEncode(payload), context, Config.REQUEST_UPDATE).then((value) {
                      callback!(false);
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.translate('i_dont_know'),style: styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appMainColor)),),
                ),
                SizedBox(width: 8,),
                appProgressButton(
                  key: progressButtonKey,
                  onPressed: isChecked!?(){
                    progressButtonKey.currentState!.show();
                    RequestUpdateRequestModel payload = RequestUpdateRequestModel();
                    payload.institutionUserId = data!.institutionUserId;
                    payload.institutionId = data!.institutionId;
                    payload.assignmentStatus = "P";
                    Calls().call(jsonEncode(payload), context, Config.REQUEST_UPDATE).then((value) {
                      var res = RequestUpdateResponseModel.fromJson(value);
                      if(res.statusCode == Strings.success_code){
                        checkReferralDetails();
                      }else{
                        ToastBuilder().showToast(res.message!, context, HexColor(AppColors.failure));
                        callback!(false);
                      }
                    }).catchError((onError){
                      progressButtonKey.currentState!.hide();
                    });
                  }:null,
                  child: Text(AppLocalizations.of(context)!.translate('submit'),style: styleElements.captionThemeScalable(context).copyWith(color: HexColor(AppColors.appColorWhite)),),
                )
              ],
            ),
          )
      ],),
    );
  }

  Widget get body{
    return appCard(
      padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 16.0),
              child: appHighlightText(
                text: getQuestion(),
                highlight: username,
                style: styleElements.headline6ThemeScalable(context),
                highlightStyle: styleElements.headline6ThemeScalable(context).copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              itemCount: (currentQuestion!=null && currentQuestion!.questionnaireOptions!=null && currentQuestion!.questionnaireOptions!.length>0)?currentQuestion!.questionnaireOptions!.length:0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text(
                  currentQuestion!.questionnaireOptions![index],style: styleElements.bodyText2ThemeScalable(context),
                ),
                  trailing: Radio(
                    onChanged: (dynamic value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    groupValue: selectedValue,
                    value: currentQuestion!.questionnaireOptions![index],
                  ),
                );
              },
            ),
            Row(
              children: [
                Spacer(),
                isVerifying?
                Padding(padding:EdgeInsets.only(right:24,bottom: 16),
                    child: CircularProgressIndicator()):
                Padding(
                  padding: EdgeInsets.only(right:24,bottom: 8),
                  child: appElevatedButton(onPressed: (){
                    setState(() {
                      isVerifying = true;
                    });
                    verify();
                  },
                    child: Text(AppLocalizations.of(context)!.translate('submit'),style: styleElements.buttonThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appColorWhite)
                    ),),),
                )
              ],
            )
          ],
        )
    );
  }

  void checkReferralDetails() async{
      var data = jsonEncode({"person_id": prefs!.getInt("userId")});
      Calls()
          .call(data, context, Config.GET_REFERRAL_DETAILS)
          .then((value) async {
        progressButtonKey.currentState!.hide();
        BasicDataForRefral basicDataForRefral =
        BasicDataForRefral.fromJson(value);
        if (basicDataForRefral.statusCode == Strings.success_code) {
          // setState(() {
          if (basicDataForRefral.rows != null && basicDataForRefral.rows!.referredByUpiId != null){
            // Navigator.pop(context);
            getScratchCardData();
          }else{
            progressButtonKey.currentState!.hide();
            // Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => ConfirmDetails(
               instId: prefs!.getInt(Strings.instituteId),
               fromPage: 'buddy',
            callbackPicker:(){callback!(true);}
            ))).then((value){
              if(value){
               callback!(value);
              }
            });
          }
          // });
        } else {
          progressButtonKey.currentState!.hide();
          ToastBuilder().showToast(basicDataForRefral.message!, context,
              HexColor(AppColors.information));
        }
      }).catchError((onError) {
        progressButtonKey.currentState!.hide();
        ToastBuilder().showToast(
            onError.toString(), context, HexColor(AppColors.information));
      });
  }

  void getScratchCardData() async {
    ScratchCardEntity scratchCardEntity = ScratchCardEntity();
    scratchCardEntity.allPersonsId = prefs!.getInt("userId");
    scratchCardEntity.scratchCardContextId = data!.personId;
    scratchCardEntity.scratchCardContext = "Buddy_Approval";
    scratchCardEntity.scratchCardSubContext = "";
    scratchCardEntity.scratchCardSubContextId = data!.personId;
    Calls()
        .call(jsonEncode(scratchCardEntity), context, Config.CARD_ALLOCATE)
        .then((value) async {
      progressButtonKey.currentState!.hide();
      if (value != null) {
        var data = ScratchCardResult.fromJson(value);
        if (data.statusCode == Strings.success_code) {
          if(data.rows!=null) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) =>
                    ScratchCardDialogue(
                      prefs!.getInt("userId"),
                      data.rows!.id,
                      data.rows!.scratchCardValue,
                      data.rows!.scratchCardRewardType,
                      fromPage: 'buddy',
                      callBack: () {
                        callback!(true);
                      },));
          }else{
            callback!(true);
          }
        }
      }
    }).catchError((onError) {
      progressButtonKey.currentState!.hide();
      ToastBuilder().showToast(onError.toString(), context, HexColor(AppColors.information));
    });
  }

  Widget getContent() {
    if(paginatorEnum == PAGINATOR_ENUMS.LOADING){
      return CustomPaginator(context).loadingWidgetMaker();
    }else if(paginatorEnum == PAGINATOR_ENUMS.ERROR || paginatorEnum==PAGINATOR_ENUMS.EMPTY){
      return CustomPaginator(context).emptyListWidgetMaker(null);
    }else{
      return questionnaireCompleted?acceptBody:body;
    }
  }

  void verify() async{
    if(currentQuestion!.questionType==BUDDY_QUESTION_TYPE.NAME.typeName){
      username = selectedValue;
    }else if(currentQuestion!.questionType==BUDDY_QUESTION_TYPE.USER_ROLE.typeName){
      role = selectedValue;
    }else if(currentQuestion!.questionType ==BUDDY_QUESTION_TYPE.INSTITUTION_NAME.typeName){
      institutionName = selectedValue;
    }else{
      className = selectedValue;
    }
    VerifyRequestModel payload = VerifyRequestModel();
    payload.buddyApprovalId = currentQuestion!.buddyApprovalId;
    payload.id = currentQuestion!.id;
    payload.questionResponse = selectedValue;
    Calls().call(jsonEncode(payload), context, Config.VERIFY_RESPONSE).then((value){
      var res= VerifyResponseModel.fromJson(value);
      isVerifying= false;
      if(res.statusCode == Strings.success_code){
        verifyResponse = res.rows;
        openNextPage();
      }else{
       isAnyWrongAnswerSubmitted = true;
       openNextPage();
      }
    });
  }

  void openNextPage() {
    if(currentQuestionIndex+1<questionsData.rows!.length) {
      setState(() {
        currentQuestionIndex++;
        currentQuestion = questionsData.rows![currentQuestionIndex];
        selectedIndex =0;
        selectedValue ='';
      });
    }else{
      if(isAnyWrongAnswerSubmitted){
        showDialog(context: context,builder: (BuildContext context){
          return ApprovalWarningDialog(
            onButtonCallback: (){
              callback!(true);
            },
          );
        });
      }
      else{
        setState(() {
          isVerifying = false;
          questionnaireCompleted = true;
        });
      }}
  }

  String getQuestion() {
   String s =  (currentQuestion!=null)?currentQuestion!.question!:'Question';
   s = s.replaceAll("_name", username!);
   s = s.replaceAll("_role",role!);
   s = s.replaceAll("_institution",className!);
   s = s.replaceAll("_institution",institutionName!);
   return s;
  }
}


