import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/ui/RoomModule/rooms_listing.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'createRoomPage.dart';

// ignore: must_be_immutable
class MyRooms extends StatefulWidget {
  int? id;
  int instituteId;
  int? ownerId;
  String? userType;
  String? ownerType;
  Null Function()? callback;
  @override
  _MyRooms createState() => _MyRooms(id, instituteId, ownerId, userType, ownerType,callback);

  MyRooms(this.id, this.instituteId, this.ownerId, this.userType, this.ownerType,this.callback);
}

class _MyRooms extends State<MyRooms> {
  TextStyleElements? styleElements;
  int? id;
  int instituteId;
  late SharedPreferences prefs;
  String? ownerType;
  int? ownerId;
  late BuildContext sctx;
  Null Function()? callback;
  String? userType;
  GlobalKey<AllRoomsListingState> allRoomsKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    ownerType = prefs.getString("ownerType");
    ownerId = prefs.getInt("userId");
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    return SafeArea(
      child: new  Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: TricycleAppBar().getCustomAppBar(context,
            appBarTitle: AppLocalizations.of(context)!.translate("rooms"),
            onBackButtonPress: () {
              Navigator.pop(context);
            }, actions: [
              GestureDetector(
                onTap: () {

                  if(prefs.getBool(Strings.isVerified)!=null&&prefs.getBool(Strings.isVerified)!)
                  { Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateRoomPage(value: null,isEdit: false,callback:(){

                            setState(() {

                            });})));}
                  else
                  {
                    ToastBuilder().showSnackBar(
                        AppLocalizations.of(context)!.translate("only_verirfied"), sctx, HexColor(AppColors.information));
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.add, color: HexColor(AppColors.appColorBlack85)),
                ),
              )
            ]),
        body:
        new Builder(builder: (BuildContext context) {
          this.sctx = context;
          return  AllRoomsListing(allRoomsKey,id, instituteId, ownerId, ownerType,userType,callback);
        }
        )
       
      ),
    );
      
      
     
  }


  _MyRooms(this.id, this.instituteId, this.ownerId, this.userType,this.ownerType,this.callback);
}
