import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/CalenderModule/calender_type_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CreateNewEventBottomSheet extends StatefulWidget {
  final Function(String? value,int ?id)? onClickCallback;
  CreateNewEventBottomSheet({this.onClickCallback});
  @override
  _CreateNewEventBottomSheet createState()=> _CreateNewEventBottomSheet(onClickCallback: onClickCallback);
}
class _CreateNewEventBottomSheet extends State<CreateNewEventBottomSheet>{
  final Function(String? value,int? id )? onClickCallback;
  _CreateNewEventBottomSheet({this.onClickCallback});
  List<CalenderTypeItem>? typeList = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => fetchData());
  }

  @override
  Widget build(BuildContext context) {
    TextStyleElements styleElements = TextStyleElements(context);
    return SafeArea(
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.only(
                topLeft:  Radius.circular(20.0),
                topRight:  Radius.circular(20.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.translate('create_new'),
                style: styleElements.headline6ThemeScalable(context),
              ),
            ),
            ListView.builder(
              itemCount: typeList!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: EdgeInsets.all(0),
                    child: InkWell(
                      onTap: (){
                        onClickCallback!(typeList![index].eventCode,typeList![index].standardEventsId);
                      },
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: typeList![index].eventDefaultImageUrl ?? '',
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          typeList!.elementAt(index).eventName!,
                          style:
                          styleElements.subtitle1ThemeScalable(context),
                        ),
                      ),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }

  void fetchData() async{
    var body = {
      "event_code":"E"
    };
    Calls().call(jsonEncode(body), context, Config.EVENT_TYPE_LIST).then((value) {
      var response = CalenderTypeList.fromJson(value);
      if(response.statusCode == Strings.success_code){
        setState(() {
          typeList = response.rows;
        });
      }
    });
  }
}