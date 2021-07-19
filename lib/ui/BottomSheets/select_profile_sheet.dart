import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/personal_profile.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SelectProfileSheet extends StatefulWidget {
  SharedPreferences prefs;
  int selectedId;
  Function(int id, String type , String imageUrl,String name) clickCallback;
  SelectProfileSheet(this.prefs,this.selectedId,this.clickCallback);

  @override
  SelectProfileSheetState createState() => SelectProfileSheetState();
}

class SelectProfileSheetState extends State<SelectProfileSheet> {
  TextStyleElements styleElements;
  List<Institutions> profiles = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getChildren());
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Wrap(children: [
        Container(
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(AppLocalizations.of(context).translate('select_profile'),
                    style: styleElements.headline6ThemeScalable(context),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 12.0),
                itemBuilder: (BuildContext context, int index) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4,bottom: 4),
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          widget.clickCallback(profiles[index].id,profiles[index].type,
                          profiles[index].profileImage,profiles[index].name);

                        },
                        child: ListTile(
                          leading: TricycleAvatar(
                            size: 48,
                            resolution_type: RESOLUTION_TYPE.R64,
                            service_type: profiles[index].type =='person'? SERVICE_TYPE.PERSON: SERVICE_TYPE.INSTITUTION,
                            imageUrl: profiles[index].profileImage,
                          ),
                          title: Text(
                            profiles[index].name,
                            style: styleElements.subtitle1ThemeScalable(context),
                          ),
                          trailing: (widget.selectedId==profiles[index].id)?Icon(
                            Icons.check_circle_rounded,color: HexColor(AppColors.appColorGreen),
                          ):null,
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                itemCount: profiles.length,
              )
            ]))
      ]),
    );
  }

  void getChildren() {
    profiles.add(Institutions(
        name: widget.prefs.getString(Strings.userName),
        id: widget.prefs.getInt(Strings.userId),
        type: 'person',
        profileImage: widget.prefs.getString(Strings.profileImage)));
    for (int i = 0;
    i < widget.prefs.getStringList(Strings.institutionIdList).length;
    i++) {
      if (widget.prefs.getStringList(Strings.personTypeList)[i] ==
          PERSON_TYPE.ADMINISTRATION.type  || widget.prefs.getStringList(Strings.personTypeList)[i] ==
          PERSON_TYPE.TEACHER.type) {
        profiles.add(Institutions(
          id: int.parse(
              widget.prefs.getStringList(Strings.institutionIdList)[i]),
          name: widget.prefs.getStringList(Strings.institutionNameList)[i],
          type: 'institution',
          profileImage: widget.prefs.getStringList(
              Strings.institutionImageList)[i],
        ));
      }
    }
    setState(() {});
  }
}
