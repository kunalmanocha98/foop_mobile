import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/appProgressButton.dart';
import 'package:oho_works_app/components/app_user_list_tile.dart';
import 'package:oho_works_app/components/appAvatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/dynmaicres.dart';
import 'package:oho_works_app/models/reportAbusePayload.dart';
import 'package:oho_works_app/ui/dialogs/reportabusethankyoudialog.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ReportAbuse extends StatefulWidget {
  int? contextId;
  String contextType;
  ReportAbuse({required this.contextId, required this.contextType});

  @override
  _ReportAbuse createState() => _ReportAbuse(contextId: contextId,contextType: contextType);
}

class _ReportAbuse extends State<ReportAbuse> {
  int? contextId;
  String contextType;
  late SharedPreferences prefs;
  GlobalKey<appProgressButtonState> progressButtonKey = GlobalKey();
  _ReportAbuse({required this.contextId, required this.contextType});
  List<CommonCardData>? listAbuses = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchList());
  }

  void fetchList() async {
    var res = await rootBundle.loadString('assets/reportabuselist.json');
    final Map parsed = json.decode(res);
    listAbuses = BaseResponses.fromJson(parsed as Map<String, dynamic>).rows;
    print("0-------------------------------------------------------------------");
    Future((){
      setState(() {});
    });
  }

  void _reportAbuse(CommonCardData item,int index) async {
    prefs = await SharedPreferences.getInstance();


    ReportAbusePayload payload = ReportAbusePayload();
    payload.reportedByType = 'person';
    payload.reportedById = prefs.getInt(Strings.userId);
    payload.reportedContextType = contextType;
    payload.reportedContextId = contextId;
    payload.abuseType = 'SPAM';
    payload.abuseDetails = item.title;
    var data = jsonEncode(payload);

    Calls().call(data, context, Config.CREATEABUSE).then((value) async {
      setState(() {
        listAbuses![index].isVerified=false;
      });


      var resposne = DynamicResponse.fromJson(value);
      if (resposne.statusCode == Strings.success_code) {
        showDialog(
            context: context,
            builder: (BuildContext context) => ReportConfirmDialog((){
              Navigator.pop(context);
            }));
      }
    }).catchError((onError) async {
      setState(() {
        listAbuses![index].isVerified=false;
      });
      print(onError.toString());
    });
  }
  late TextStyleElements styleElements;
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: OhoAppBar().getCustomAppBar(
            context,
            appBarTitle: AppLocalizations.of(context)!.translate('report_content'),
            onBackButtonPress: (){Navigator.pop(context);}),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16),
              child: ListTile(
                title: Text(
                  AppLocalizations.of(context)!.translate("why_report"),
                  style: styleElements.subtitle1ThemeScalable(context).copyWith(
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
            ),
            Expanded(
                child:ListView.builder(
                    padding: EdgeInsets.only(top: 4, left: 8, right: 8, bottom: 4),
                    itemCount: listAbuses!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return


                        InkWell(

                          onTap: () async {

                            print("0-------------------------------------------------------------------");
                            _reportAbuse(listAbuses![index],index);
                            setState(() {
                              listAbuses![index].isVerified=true;
                            });
                          },
                          child: ListTile(
                            title: Text(listAbuses![index].title!),
                            leading: SizedBox(
                              height: 52,
                              width: 52,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child:Image(
                                      image: AssetImage('assets/appimages/avatar-default.png'),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            trailing: Visibility(
                              visible: listAbuses![index].isVerified!=null&&listAbuses![index].isVerified!,
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ));
                    }))
          ],
        ),
      ),
    );
  }
}
