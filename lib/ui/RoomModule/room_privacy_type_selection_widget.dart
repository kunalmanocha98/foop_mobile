import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/Rooms/privacy_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomPrivacyTypeWidget extends StatefulWidget{
  final String selectedValue;
  RoomPrivacyTypeWidget({Key key, this.selectedValue=""}):super(key: key);
  @override
  RoomPrivacyTypeWidgetState createState() => RoomPrivacyTypeWidgetState(selectedTypeCode: selectedValue);
}
class RoomPrivacyTypeWidgetState extends State<RoomPrivacyTypeWidget>{

  String selectedTypeCode;
  SharedPreferences _prefs;
  List<PrivacyListItem> _privacyList = [];
  RoomPrivacyTypeWidgetState({this.selectedTypeCode});
  bool isFixed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getPrivacyList());
  }
  String get getSelectedTypeCode => this.selectedTypeCode;

  void setPrivacyType(String privacyType) {
    setState(() {
      selectedTypeCode = privacyType;
      isFixed = (selectedTypeCode!=null && selectedTypeCode.isNotEmpty);
    });
  }

  _getPrivacyList() async{
    _prefs ??= await SharedPreferences.getInstance();
    RoomPrivacyTypeRequest payload = RoomPrivacyTypeRequest();
    payload.pageNumber = 1;
    payload.pageSize= 20;
    Calls().call(jsonEncode(payload), context, Config.ROOM_PRIVACY_TYPE_LIST).then((value){
      var res = RoomPrivacyListResponse.fromJson(value);
      if(res.statusCode == Strings.success_code){
        setState(() {
          _privacyList.addAll(res.rows);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        itemExtent: (MediaQuery.of(context).size.width-48)/4,
        itemCount: _privacyList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return  GestureDetector(
              onTap: (){
                if(!isFixed) {
                  setState(() {
                    selectedTypeCode = _privacyList[index].privacyTypeCode;
                  });
                }
              },
              child: _SelectionWidget(title:_privacyList[index].privacyTypeName,url: _privacyList[index].imageUrl,isSelected: selectedTypeCode == _privacyList[index].privacyTypeCode,));
        },
      ),
    );
  }


}

class _SelectionWidget extends StatelessWidget{
  final bool isSelected;
  final String url;
  final String title;
  _SelectionWidget({this.isSelected=false,this.url,this.title});
  @override
  Widget build(BuildContext context) {
    final TextStyleElements styleElements = TextStyleElements(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:  isSelected?HexColor(AppColors.appMainColor).withOpacity(0.35):HexColor(AppColors.appColorWhite),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TricycleAvatar(
              imageUrl: Config.BASE_URL+url,
              // imageUrl: "https://test.tricycle.group/logo.png",
              isFullUrl: true,
              key: UniqueKey(),
              size: 48,
              borderSize: 6,
              isClickable: false,
              withBorder: false,
              service_type: SERVICE_TYPE.PERSON,
              resolution_type: RESOLUTION_TYPE.R64,
              borderColor:HexColor(AppColors.appColorWhite),
            ),
            SizedBox(height: 8,),
            Text(title,style: styleElements.subtitle2ThemeScalable(context),)
          ],
        ),
      ),
    );
  }

}