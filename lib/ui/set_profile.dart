// ignore: must_be_immutable

import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/common_cards/testcard.dart';
import 'package:oho_works_app/regisration_module/welcomePage.dart';
import 'package:oho_works_app/ui/person_type_list.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String type;
  int? currentPosition;

  Profile({Key? key, required this.type}) : super(key: key);

  _SetProfile createState() => _SetProfile();
}

// ignore: must_be_immutable
class _SetProfile extends State<Profile> {
  String? type;
  List<StatelessWidget> listCardsAbout = [];
  List<PersonItem> rows = [];
  ProgressDialog? pr;
  List<CommonCardData> listCardData = [];
  late TextStyleElements styleElements;

  @override
  void initState() {
    super.initState();
    // loadPages();
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: HexColor(AppColors.appColorBackground),
        appBar:
        OhoAppBar().getCustomAppBarWithSearch(context,
            appBarTitle: AppLocalizations.of(context)!.translate("i_am"),
            onBackButtonPress: (){},
            onSearchValueChanged: (value) {

            }),
        body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate("set_role"),
                        style: styleElements.bodyText1ThemeScalable(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelComeScreen(

                              ),
                            ));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: Text(AppLocalizations.of(context)!.translate('set_another_role'),
                                  style: styleElements.headline6ThemeScalable(context),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                      ),
                    )),
              ];
            },
            body: Column(
              children: <Widget>[
                Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 60),
                      child: NotificationListener(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: listCardsAbout.length,
                            itemBuilder: (context, index) {
                              return listCardsAbout[index];
                            }),
                        // ignore: missing_return

                      ),
                    ))
              ],
            )),
      ),
    );
  }

  // loadPages() async {
  //   var resAbout;
  //   resAbout = await rootBundle.loadString('assets/set.json');
  //
  //   final Map parsedAbout = json.decode(resAbout);
  //   listCardData = BaseResponses.fromJson(parsedAbout).rows;
  //   // for (var item in listCardData) {
  //   //   /*   listCardsAbout.add(GetAllCards().getCard(item));*/
  //   // }
  //
  //   if (this.mounted) {
  //     setState(() {
  //       listCardsAbout = listCardsAbout;
  //     });
  //   }
  // }
}
