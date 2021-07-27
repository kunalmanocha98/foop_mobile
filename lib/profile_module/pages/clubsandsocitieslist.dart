
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/searchBox.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/profile_module/common_cards/overlaped_circular_images.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ClubsAndSocieties extends StatefulWidget {
  @override
  _ClubsAndSocieties createState() => _ClubsAndSocieties();
}

class _ClubsAndSocieties extends State<ClubsAndSocieties> {
  List<SubRow> listSubItems = [];
  List<CommonCardData> listCardData = [];
  List<StatelessWidget> listCardsAbout = [];
  late TextStyleElements styleElements;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => fetchlist());
  }

  // void fetchlist() async {
  //   var resAbout = await rootBundle.loadString('assets/clubs_card.json');
  //   final Map parsedAbout = json.decode(resAbout);
  //   listCardData = BaseResponses.fromJson(parsedAbout).rows;
  //   for (var item in listCardData) {
  //     if (item.cardName == 'ClubAndSocities') {
  //       listSubItems = item.subRow;
  //       break;
  //     }
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: TricycleAppBar().getCustomAppBar(context,
              appBarTitle: AppLocalizations.of(context)!
                  .translate("clubs_societies"), onBackButtonPress: () {
                Navigator.pop(context);
              }),
          body: Scaffold(
            resizeToAvoidBottomInset: false,
            body: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                      child: SearchBox(
                        onvalueChanged: (String value) {
                          setState(() {});
                        },
                        hintText: AppLocalizations.of(context)!.translate('search'),
                        progressIndicator: false,
                      )),
                ];
              },
              body: Container(
                margin: EdgeInsets.only(top: 36),
                child: Stack(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: listSubItems.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => CommonDetailPage(
                              //         id: "",
                              //       ),
                              //     ));
                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 120,
                                  child: Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        gradient: new LinearGradient(
                                            colors: [
                                              Color(int.parse(listSubItems[index]
                                                  .gradientOne!)),
                                              Color(int.parse(listSubItems[index]
                                                  .gradientTwo!)),
                                            ],
                                            begin:
                                            const FractionalOffset(0.0, 0.0),
                                            end: const FractionalOffset(1.0, 0.0),
                                            stops: [0.0, 1.0],
                                            tileMode: TileMode.clamp),
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    margin: EdgeInsets.all(10),
                                  ),
                                ),
                                Positioned(
                                    top: 8.0,
                                    left: 4.0,
                                    right: 4.0,
                                    child: Row(
                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 4,
                                                  top: 16,
                                                  bottom: 16),
                                              child: Image(
                                                image: CachedNetworkImageProvider(
                                                    listSubItems[index].urlOne ??=
                                                    ""),
                                                fit: BoxFit.fill,
                                                width: 60,
                                                height: 60,
                                              )),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Column(children: <Widget>[
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    top: 16.0),
                                                child: Text(
                                                  listSubItems[index].textOne ??=
                                                  "",
                                                  style: styleElements
                                                      .headline5ThemeScalable(
                                                      context),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 16.0),
                                                child: Text(
                                                  listSubItems[index].textTwo ??=
                                                  "",
                                                  style: styleElements
                                                      .subtitle1ThemeScalable(
                                                      context)
                                                      .copyWith(
                                                      color: HexColor(AppColors.appColorWhite)),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                const EdgeInsets.all(16.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    OverlappedImages(null),
                                                    Flexible(
                                                      child: Text(
                                                        listSubItems[index]
                                                            .textThree ??= "",
                                                        style: styleElements
                                                            .subtitle1ThemeScalable(
                                                            context)
                                                            .copyWith(
                                                            color:
                                                            HexColor(AppColors.appColorWhite)),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          ]),
                                        ),
                                        Container(
                                          width: 60,
                                          height: 30,
                                          margin: const EdgeInsets.all(16),
                                          child: TricycleElevatedButton(
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate('join')),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                side: BorderSide(
                                                    color: HexColor(AppColors.appColorWhite65))),
                                            onPressed: () {},
                                            color: HexColor(AppColors.appColorWhite),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
