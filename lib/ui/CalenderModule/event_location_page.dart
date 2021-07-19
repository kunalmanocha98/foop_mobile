
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/mixins/someCommonMixins.dart';
import 'package:oho_works_app/models/CalenderModule/event_create_models.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventLocationPage extends StatefulWidget {
  @override
  EventLocationPageState createState() => EventLocationPageState();
}

class EventLocationPageState extends State<EventLocationPage> {
  TextStyleElements styleElements;
  TextEditingController controller = TextEditingController();
  String address;
  String country;
  String state;
  String city;
  String pin;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);

    Widget country = TextFormField(
      keyboardType: TextInputType.text,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      textCapitalization: TextCapitalization.sentences,
      onChanged: (text) {},
      validator: CommonMixins().validateTextField,
      onSaved: (value){
        this.country = value;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter Country",
          hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
      ),
    );

    final state = TextFormField(
      keyboardType: TextInputType.text,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      textCapitalization: TextCapitalization.sentences,
      onChanged: (text) {},
      validator: CommonMixins().validateTextField,
      onSaved: (value){
        this.state = value;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter State",
        hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
      ),
    );

    final city = TextFormField(
      keyboardType: TextInputType.text,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      textCapitalization: TextCapitalization.sentences,
      onChanged: (text) {},
      validator: CommonMixins().validateTextField,
      onSaved: (value){
        this.city = value;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter City",
        hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
      ),
    );

    final pin = TextFormField(
      keyboardType: TextInputType.number,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      textCapitalization: TextCapitalization.sentences,
      onChanged: (text) {},
      validator: CommonMixins().validateTextField,
      onSaved: (value){
        this.pin = value;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter Pin",
        hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
      ),
    );

    final address = TextFormField(
      keyboardType: TextInputType.streetAddress,
      style: styleElements.subtitle1ThemeScalable(context).copyWith(
          color: HexColor(AppColors.appColorBlack65)
      ),
      textCapitalization: TextCapitalization.sentences,
      maxLines: 5,
      onChanged: (text) {},
      validator: CommonMixins().validateTextField,
      onSaved: (value){
        this.address = value;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter Address",
        border:  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35)),
      ),
    );


    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBar(context,
            actions: [
              TricycleTextButton(
                onPressed: () {
                  updateLocation();
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context).translate('next'),
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: HexColor(AppColors.appMainColor))
                  ],
                ),
                shape: CircleBorder(),
              ),
            ],
            appBarTitle: 'Event Location', onBackButtonPress: () {
              Navigator.pop(context);
            }),
        body: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TricycleListCard(
                padding: EdgeInsets.all(16),
                child: TextField(
                  style: styleElements.subtitle1ThemeScalable(context).copyWith(
                      color: HexColor(AppColors.appColorBlack65)
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter event location(map)',
                    hintStyle: styleElements.bodyText2ThemeScalable(context).copyWith(color:HexColor(AppColors.appColorBlack35))
                  ),
                ),
              ),
              TricycleListCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(padding:EdgeInsets.all(6),child: address),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(flex:1,child: Container(padding: EdgeInsets.all(6),child: country)),
                          Flexible(flex:1,child: Container(padding: EdgeInsets.all(6),child: state)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Flexible(flex:1,child: Container(padding: EdgeInsets.all(6),child: city)),
                          Flexible(flex:1,child: Container(padding: EdgeInsets.all(6),child: pin)),
                        ],
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateLocation() {
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      var location = EventLocation(
        type: 'offline',
        address: Address(
          address: address,
          city: city,
          state: state,
          country: country,
          pincode: pin
        )
      );
      Navigator.pop(context,location);
    }
  }
}
