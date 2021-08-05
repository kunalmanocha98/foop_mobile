
import 'package:flutter/material.dart';
import 'package:oho_works_app/components/app_buttons.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/models/email_module/domain_create.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';

class DomainListCard extends StatefulWidget {
  final VoidCallback? buyEmailCallback;
  final VoidCallback? createEmailCallback;
  final DomainListItem? cardData;
  final VoidCallback? removeCallback;

  DomainListCard({
    this.buyEmailCallback,
    this.createEmailCallback,
    this.cardData,
    this.removeCallback,
  });

  @override
  _DomainListCard createState() => _DomainListCard(cardData: cardData);
}

class _DomainListCard extends State<DomainListCard> {
  TextStyleElements? styleElements;
  DomainListItem? cardData;

  _DomainListCard({this.cardData});

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return appListCard(
      padding: EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Domain details",
                      style: styleElements!
                          .subtitle1ThemeScalable(context)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    appTextButton(
                      onPressed: widget.removeCallback,
                      shape: StadiumBorder(),
                      child: Text(
                        "Remove",
                        style: styleElements!
                            .bodyText2ThemeScalable(context)
                            .copyWith(color: HexColor(AppColors.appMainColor)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, right: 4.0, bottom: 4, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Domain",
                                style: styleElements!
                                    .bodyText2ThemeScalable(context),
                              ),
                              Text(
                                cardData!.domainName ?? "-",
                                style: styleElements!
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 56,
                        width: 1,
                        color: HexColor(AppColors.appColorBlack35),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, right: 4.0, bottom: 4, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Type",
                                style: styleElements!
                                    .bodyText2ThemeScalable(context),
                              ),
                              Text(
                                cardData!.type!.toUpperCase(),
                                style: styleElements!
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, right: 4.0, bottom: 4, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Status",
                                style: styleElements!
                                    .bodyText2ThemeScalable(context),
                              ),
                              Text(
                                cardData!.domainStatus!.toUpperCase(),
                                style: styleElements!
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 56,
                        width: 1,
                        color: HexColor(AppColors.appColorBlack35),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, right: 4.0, bottom: 4, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Subscribed",
                                style: styleElements!
                                    .bodyText2ThemeScalable(context),
                              ),
                              Text(
                                cardData!.totalEmails.toString(),
                                style: styleElements!
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, right: 4.0, bottom: 4, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "User Ids",
                                style: styleElements!
                                    .bodyText2ThemeScalable(context),
                              ),
                              Text(
                                cardData!.totalEmailsUsed.toString(),
                                style: styleElements!
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 56,
                        width: 1,
                        color: HexColor(AppColors.appColorBlack35),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, right: 4.0, bottom: 4, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Free",
                                style: styleElements!
                                    .bodyText2ThemeScalable(context),
                              ),
                              Text(
                                cardData!.totalFreeEmails.toString(),
                                style: styleElements!
                                    .subtitle1ThemeScalable(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: HexColor(AppColors.appMainColor),
          ),
          Row(
            children: [
              Expanded(
                  child: InkWell(
                    onTap: widget.buyEmailCallback,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: HexColor(AppColors.appMainColor),
                                  width: 0.5))),
                      child: Center(
                        child: Text(
                          'Create Email ids',
                          style: styleElements!
                              .captionThemeScalable(context)
                              .copyWith(color: HexColor(AppColors.appMainColor)),
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  child: InkWell(
                    onTap: widget.createEmailCallback,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: HexColor(AppColors.appMainColor),
                                  width: 0.5))),
                      child: Center(
                        child: Text(
                          'Buy more ids',
                          style: styleElements!
                              .captionThemeScalable(context)
                              .copyWith(color: HexColor(AppColors.appMainColor)),
                        ),
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
