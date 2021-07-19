import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/material.dart';

class SpeakersList extends StatefulWidget {
  @override
  SpeakersListState createState() => SpeakersListState();
}

class SpeakersListState extends State<SpeakersList> {
  TextStyleElements styleElements;

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBarWithSearch(
          context,
          appBarTitle: AppLocalizations.of(context).translate('manage_speaker'),
          onBackButtonPress: () {
            Navigator.pop(context);
          },
          hintText: 'Search members,rooms, channels',
          onSearchValueChanged: (String value) {},
        ),
        body: TricycleListCard(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TricycleAvatar(
                      size: 56,
                      imageUrl: 'https://picsum.photos/100/100',
                      service_type: SERVICE_TYPE.PERSON,
                      resolution_type: RESOLUTION_TYPE.R64,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left:8.0,right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kunal Manocha',style:styleElements.subtitle1ThemeScalable(context),maxLines: 1,overflow: TextOverflow.ellipsis),
                            Text('Teacher, Humpty Dumpty School',style: styleElements.bodyText2ThemeScalable(context),maxLines: 1,overflow: TextOverflow.ellipsis,)
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TricycleTextButton(
                            onPressed: () {},
                            shape: StadiumBorder(
                              side: BorderSide(color: HexColor(AppColors.appColorWhite)),
                            ),
                            child: Text(
                              'Reject',

                              style: styleElements.captionThemeScalable(context).copyWith(
                                color: HexColor(AppColors.appMainColor)
                              ),
                            )),
                        TricycleTextButton(
                            onPressed: () {},
                            child: Text(
                              'Allow',
                              style: styleElements.captionThemeScalable(context).copyWith(
                                color: HexColor(AppColors.appMainColor)
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
