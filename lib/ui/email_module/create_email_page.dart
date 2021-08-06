import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/mixins/editProfileMixin.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/email_module/domain_create.dart';
import 'package:oho_works_app/models/email_module/email_user_create.dart';
import 'package:oho_works_app/models/email_module/email_user_list.dart';
import 'package:oho_works_app/models/email_module/global_user_list_response.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEmailPage extends StatefulWidget {
  final EmailUserListItem? data;
  final bool isUpdate;

  CreateEmailPage({this.data, this.isUpdate = false});

  @override
  _CreateEmailPage createState() => _CreateEmailPage();
}

class _CreateEmailPage extends State<CreateEmailPage>
    with CommonMixins, EditProfileMixins {
  TextStyleElements? styleElements;
  String? email;
  String? password;
  String? confirmPassword;
  String? first_name;
  String? last_name;
  String? recovery_email;
  GlobalKey<FormState> formKey = GlobalKey();
  DomainListItem? domainDetail;
  SharedPreferences prefs = locator<SharedPreferences>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController recoveryEmailController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalUserListItem? userDetail;
  GlobalKey<appProgressButtonState> progressButtonSave = GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonSaveandExit =
  GlobalKey();
  GlobalKey<appProgressButtonState> progressButtonUpdate = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchDetails();
    });
  }

  void fetchDetails() async {
    DomainCreateRequest payload = DomainCreateRequest();
    payload.ownerType = prefs.getString(Strings.ownerType)!;
    payload.ownerId = prefs.getInt(Strings.userId)!;
    var value = await Calls().call(
        jsonEncode(payload), context, Config.EMAIL_DOMAIN_LIST,
        isMailToken: true);
    var res = DomainListResponse.fromJson(value);
    setState(() {
      domainDetail = res.rows![0];
      if (widget.isUpdate) {
        emailController.text =
            widget.data!.emailId!.replaceAll("@${domainDetail!.domainName}", "");
        firstNameController.text = widget.data!.title!.split(" ")[0];
        lastNameController.text = widget.data!.title!.split(" ")[1];
      }
    });
  }

  // TextFormField(
  // validator: validateTextField,
  // onSaved: (value) {
  // first_name = value;
  // },
  // decoration: InputDecoration(
  // hintText: "First Name",
  // contentPadding: EdgeInsets.only(
  // left: 12, top: 16, bottom: 8),
  // border: UnderlineInputBorder(
  // borderRadius: BorderRadius.circular(12)),
  // floatingLabelBehavior:
  // FloatingLabelBehavior.auto,
  // labelText: "First Name"),
  // ),
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    final firstNameTypeAhead = TypeAheadField(
      direction: AxisDirection.up,
      hideOnLoading: true,
      textFieldConfiguration: TextFieldConfiguration(
        autofocus: false,
        enabled: !widget.isUpdate,
        controller: firstNameController,
        textCapitalization: TextCapitalization.words,
        onChanged: (text) {
          if (text.length == 1 && text != text.toUpperCase()) {
            firstNameController.text = text.toUpperCase();
            firstNameController.selection = TextSelection.fromPosition(
                TextPosition(offset: firstNameController.text.length));
          }
        },
        // style: styleElements
        //     .subtitle1ThemeScalable(context).copyWith(
        //     color: HexColor(AppColors.appColorBlack65)
        // ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 12, top: 16, bottom: 8),
          hintText: "First name",
          labelText: "First name",
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: UnderlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      suggestionsCallback: (pattern) async {
        var data = jsonEncode(
            {"search_val": pattern, "page_number": 1, "page_size": 4});
        var value = await Calls().call(
            data, context, Config.EMAIL_GLOBAL_USER_LIST,
            isMailToken: true);
        return GlobalUserListResponse.fromJson(value).rows!;
      },
      itemBuilder: (context, suggestion) {
        GlobalUserListItem? item = suggestion as GlobalUserListItem?;
        return ListTile(
          title: Text(item!.title!),
        );
      },
      onSuggestionSelected: (suggestion) {
        setState(() {
          userDetail = suggestion as GlobalUserListItem?;
          firstNameController.text = userDetail!.title!.split(" ")[0];
          lastNameController.text = userDetail!.title!.split(" ")[1];
          recoveryEmailController.text = userDetail!.email!;
        });
      },
    );
    return SafeArea(
      child: Scaffold(
        appBar: OhoAppBar().getCustomAppBar(
          context,
          appBarTitle: AppLocalizations.of(context)!.translate('create_email'),
          onBackButtonPress: () {
            Navigator.pop(context);
          },
        ),
        body: Form(
          key: formKey,
          child: Container(
            child: SingleChildScrollView(
              child: domainDetail == null
                  ? CustomPaginator(context).loadingWidgetMaker()
                  : appListCard(
                padding: EdgeInsets.only(
                    top: 20, left: 16, right: 16, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Email details",
                        style: styleElements!
                            .subtitle1ThemeScalable(context)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text(
                        "Enter your desired email id",
                        style:
                        styleElements!.bodyText1ThemeScalable(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: HexColor(AppColors.appColorBackground),
                        ),
                        child: TextFormField(
                          validator: validateTextField,
                          controller: emailController,
                          onSaved: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                              hintText: "Enter email id",
                              enabled: !widget.isUpdate,
                              suffixText: "@${domainDetail!.domainName}",
                              suffixStyle: styleElements!
                                  .headline6ThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(
                                      AppColors.appColorBlack85)),
                              contentPadding: EdgeInsets.only(
                                  left: 12,
                                  top: 16,
                                  bottom: 8,
                                  right: 16),
                              border: UnderlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.auto,
                              labelText: "Enter your desired email id"),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: HexColor(
                                    AppColors.appColorBackground),
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                validator: validatePassword,
                                obscureText: true,
                                onSaved: (value) {
                                  password = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Enter password",
                                    contentPadding: EdgeInsets.only(
                                        left: 12, top: 16, bottom: 8),
                                    border: UnderlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(12)),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                    labelText: "Password"),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: HexColor(
                                    AppColors.appColorBackground),
                              ),
                              child: TextFormField(
                                controller: confirmPasswordController,
                                validator: validatePassword,
                                obscureText: true,
                                onSaved: (value) {
                                  confirmPassword = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Repeat password",
                                    contentPadding: EdgeInsets.only(
                                        left: 12, top: 16, bottom: 8),
                                    border: UnderlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(12)),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                    labelText: "Repeat password"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your email password is different from your Tricycle password. It should contain a minimum of 8 characters with at least one special character and a number.",
                        style:
                        styleElements!.bodyText2ThemeScalable(context),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                padding: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: HexColor(
                                      AppColors.appColorBackground),
                                ),
                                child: firstNameTypeAhead),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: HexColor(
                                    AppColors.appColorBackground),
                              ),
                              child: TextField(
                                controller: lastNameController,
                                enabled: !widget.isUpdate,
                                onChanged: (value) {
                                  last_name = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Second Name",
                                    contentPadding: EdgeInsets.only(
                                        left: 12, top: 16, bottom: 8),
                                    border: UnderlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(12)),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                    labelText: "Second Name"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your name is out of your profile info. If you change here, the name is changed in your profile also.",
                        style:
                        styleElements!.bodyText2ThemeScalable(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Recovery email",
                        style:
                        styleElements!.bodyText1ThemeScalable(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: HexColor(AppColors.appColorBackground),
                        ),
                        child: TextFormField(
                          controller: recoveryEmailController,
                          validator: validateEmail,
                          onSaved: (value) {
                            recovery_email = value;
                          },
                          enabled:
                          !(userDetail != null || widget.isUpdate),
                          decoration: InputDecoration(
                            hintText: "Recovery email",
                            contentPadding: EdgeInsets.only(
                                left: 12, top: 16, bottom: 8),
                            border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your recovery email will always be your primary Tricycle Login email that you have provided. You can change it.",
                        style:
                        styleElements!.bodyText2ThemeScalable(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "A confirmation email with email & password is sent to Registered email & phone",
                        style:
                        styleElements!.bodyText2ThemeScalable(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.isUpdate
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          appProgressButton(
                            onPressed: () {

                                if (passwordController.text ==
                                    confirmPasswordController.text) {
                                  updateEmail();
                                } else {
                                  ToastBuilder().showToast(
                                      AppLocalizations.of(context)!
                                          .translate(
                                          'password_not_matching'),
                                      context,
                                      HexColor(AppColors.information));
                                }


                            },
                            key: progressButtonUpdate,
                            padding: EdgeInsets.only(
                                left: 16, right: 16),
                            color: HexColor(AppColors.appMainColor),
                            child: Text(
                              "Update",
                              style: styleElements!
                                  .bodyText1ThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(AppColors.appColorWhite)),
                            ),
                          ),
                        ],
                      )
                          : Row(
                        children: [
                          appProgressButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if (password == confirmPassword) {
                                  createEmail();
                                } else {
                                  ToastBuilder().showToast(
                                      AppLocalizations.of(context)!
                                          .translate(
                                          'password_not_matching'),
                                      context,
                                      HexColor(
                                          AppColors.information));
                                }
                              }
                            },
                            key: progressButtonSave,
                            padding: EdgeInsets.only(
                                left: 16, right: 16),
                            color: HexColor(AppColors.appMainColor),
                            child: Text(
                              "Save",
                              style: styleElements!
                                  .bodyText1ThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(
                                      AppColors.appColorWhite)),
                            ),
                          ),
                          Spacer(),
                          appProgressButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                if (password == confirmPassword) {
                                  createEmail(exit: true);
                                } else {
                                  ToastBuilder().showToast(
                                      AppLocalizations.of(context)!
                                          .translate(
                                          'password_not_matching'),
                                      context,
                                      HexColor(
                                          AppColors.information));
                                }
                              }
                            },
                            key: progressButtonSaveandExit,
                            padding: EdgeInsets.only(
                                left: 16, right: 16),
                            color: HexColor(AppColors.appMainColor),
                            child: Text(
                              "Save & Exit",
                              style: styleElements!
                                  .bodyText1ThemeScalable(context)
                                  .copyWith(
                                  color: HexColor(
                                      AppColors.appColorWhite)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createEmail({bool exit = false}) async {
    if (exit)
      progressButtonSaveandExit.currentState!.show();
    else
      progressButtonSave.currentState!.show();
    EmailUserCreateRequest payload = EmailUserCreateRequest();
    payload.emailId = email! + "@" + domainDetail!.domainName!;
    payload.password = password!;
    payload.firstName = firstNameController.text;
    payload.lastName = lastNameController.text;
    payload.customerEmailDetailsId = domainDetail!.id;
    payload.emailPersonId = userDetail!.id;
    payload.emailRecoveryEmailId = recovery_email!;
    Calls()
        .call(jsonEncode(payload), context, Config.EMAIL_USER_EXIST,
        isMailToken: true)
        .then((value) {
      var res = EmailUserExistResponse.fromJson(value);
      if (exit)
        progressButtonSaveandExit.currentState!.hide();
      else
        progressButtonSave.currentState!.hide();
      if (res.rows!.isExists) {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("email_exist"),
            context,
            HexColor(AppColors.information));
      } else {
        if (exit)
          progressButtonSaveandExit.currentState!.show();
        else
          progressButtonSave.currentState!.show();
        Calls()
            .call(jsonEncode(payload), context, Config.EMAIL_USER_CREATE,
            isMailToken: true)
            .then((value) {
          var res = CreateEmailUserResponse.fromJson(value);
          if (exit)
            progressButtonSaveandExit.currentState!.hide();
          else
            progressButtonSave.currentState!.hide();
          if (res.statusCode == Strings.success_code) {
            ToastBuilder().showToast(
                AppLocalizations.of(context)!
                    .translate("email_created_successfully"),
                context,
                HexColor(AppColors.information));
            if (exit) {
              Navigator.pop(context);
            } else {
              clear();
            }
          }
        });
      }
    });
  }

  void clear() {
    emailController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
    firstNameController.text = "";
    lastNameController.text = "";
    recoveryEmailController.text = "";
    userDetail = null;
  }

  void updateEmail() async {
    progressButtonUpdate.currentState!.show();
    var data = jsonEncode(
        {"username": widget.data!.emailId, "password": passwordController.text});
    Calls().call(data, context, Config.EMAIL_PASSWORD_UPDATE,isMailToken: true).then((value) {
      progressButtonUpdate.currentState!.hide();
      var res = CreateEmailUserResponse.fromJson(value);
      if (res.statusCode == Strings.success_code) {
        ToastBuilder().showToast(
            AppLocalizations.of(context)!.translate("updated_successfully"),
            context,
            HexColor(AppColors.information));
        Navigator.pop(context, true);
      }
    }).catchError((onError){
      print(onError);
      progressButtonUpdate.currentState!.hide();
    });
  }
}
