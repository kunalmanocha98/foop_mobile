import 'package:oho_works_app/enums/personType.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewBottomSheet extends StatelessWidget {
  final Function(String value) onClickCallback;
  final SharedPreferences prefs;
  final isRoomsVisible;
  CreateNewBottomSheet({this.onClickCallback,this.prefs,this.isRoomsVisible=true});
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: HexColor(AppColors.appMainColor),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('create_new'),
                      style: styleElements.headline6ThemeScalable(context).copyWith(
                        color: HexColor(AppColors.appColorWhite)
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).translate("create_lesson_desc"),
                      style: styleElements.subtitle1ThemeScalable(context).copyWith(
                          color: HexColor(AppColors.appColorWhite)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row(
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('feed');
                //         },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(12),
                //                   color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                     width: 24,
                //                       height: 24,
                //                       child: Icon(Icons.note_add_outlined)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('feed_post'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                     color: HexColor(AppColors.appColorBlack65)
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('qa');
                //           },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(12),
                //                     color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                       width: 24,
                //                       height: 24,
                //                       child:Icon(Icons.help_center_outlined)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('qnA'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                     color: HexColor(AppColors.appColorBlack65)
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('blog');
                //         },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(12),
                //                     color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                       width: 24,
                //                       height: 24,
                //                       child: Icon(Icons.description_outlined)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('blog'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                     color: HexColor(AppColors.appColorBlack65)
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('poll');
                //         },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(12),
                //                     color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                       width: 24,
                //                       height: 24,
                //                       child:Icon(Icons.ballot_outlined)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('poll'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                     color: HexColor(AppColors.appColorBlack65)
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 36,),
                // Row(
                //   children: [
                //     prefs.getStringList(Strings.personTypeList).contains(PERSON_TYPE.TEACHER.type)?Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('notice');
                //         },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(12),
                //                     color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                       width: 24,
                //                       height: 24,
                //                       child: Icon(Icons.campaign_outlined)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('notice'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                     color: HexColor(AppColors.appColorBlack65)
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ):Container(),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('news');
                //         },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(12),
                //                     color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                       width: 24,
                //                       height: 24,
                //                       child: Icon(Icons.article_outlined)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('campus_news'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                     color: HexColor(AppColors.appColorBlack65)
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('assignment');
                //         },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(12),
                //                     color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                       width: 24,
                //                       height: 24,
                //                       child: Icon(Icons.assignment_outlined)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('assignment'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                                       color: HexColor(AppColors.appColorBlack65)
                //                                     ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //     isRoomsVisible?Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('room');
                //         },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(12),
                //                     color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                       width: 24,
                //                       height: 24,
                //                       child: Icon(Icons.group_outlined)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('room'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                     color: HexColor(AppColors.appColorBlack65)
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ):Container(),
                //   ],
                // ),
                // SizedBox(height: 36,),
                // Row(
                //   children: [
                //     Expanded(
                //       child: GestureDetector(
                //         onTap: (){
                //           onClickCallback('learning');
                //         },
                //         child: Center(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               Container(
                //                 height: 56,
                //                 width: 56,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(12),
                //                     color: HexColor(AppColors.appColorBackground)
                //                 ),
                //                 child: Center(
                //                   child: SizedBox(
                //                       width: 24,
                //                       height: 24,
                //                       child: Icon(Icons.pages)),
                //                 ),
                //               ),
                //               SizedBox(height: 6,),
                //               Text(
                //                 AppLocalizations.of(context).translate('learning'),
                //                 style: styleElements.captionThemeScalable(context).copyWith(
                //                     color: HexColor(AppColors.appColorBlack65)
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('feed');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Icon(Icons.note_add_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('feed_post'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('qa');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child:Icon(Icons.help_center_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('qnA'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('blog');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Icon(Icons.description_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('blog'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('poll');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child:Icon(Icons.ballot_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('poll'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if(prefs.getStringList(Strings.personTypeList).contains(PERSON_TYPE.TEACHER.type))
                      Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('notice');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Icon(Icons.campaign_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('notice'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('news');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Icon(Icons.article_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('campus_news'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('assignment');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Icon(Icons.assignment_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('assignment'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if(isRoomsVisible)
                      Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('room');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Icon(Icons.group_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('room'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:18,bottom: 18),
                      width: MediaQuery.of(context).size.width/4,
                      child: GestureDetector(
                        onTap: (){
                          onClickCallback('lesson');
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: HexColor(AppColors.appColorBackground)
                                ),
                                child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Icon(Icons.school_outlined)),
                                ),
                              ),
                              SizedBox(height: 6,),
                              Text(
                                AppLocalizations.of(context).translate('lessons'),
                                style: styleElements.captionThemeScalable(context).copyWith(
                                    color: HexColor(AppColors.appColorBlack65)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 30,),
        ])
      ),
    );
  }
}