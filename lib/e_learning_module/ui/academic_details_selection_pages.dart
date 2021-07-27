import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/components/CustomPaginator.dart';
import 'package:oho_works_app/components/appBarWithSearch.dart';
import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/paginator.dart';
import 'package:oho_works_app/components/tricycle_buttons.dart';
import 'package:oho_works_app/models/e_learning/academic_details_selection_model.dart';
import 'package:oho_works_app/models/post/postcreate.dart';
import 'package:oho_works_app/models/post/postreceiver.dart';
import 'package:oho_works_app/ui/postrecieverlistpage.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/app_localization.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/toast_builder.dart';
import 'package:flutter/material.dart';

class AcademicDetailsSelectionPages extends StatefulWidget {
  final List<AcademicDetailSelectionItem>? selectedList;
  final AcademicDetailType? type;
  final String? category_type;
  final List<PostCreatePayload?>? list;
  final Function? callBack;
  final PostReceiverListItem? selectedReceiverData;
  final PostCreatePayload? createLessonData;
  AcademicDetailsSelectionPages({
    this.selectedList,
    this.type,
    this.callBack,
    this.createLessonData,
    this.category_type, this.list, this.selectedReceiverData,
  });

  @override
  AcademicDetailsSelectionPagesState createState() =>
      AcademicDetailsSelectionPagesState(
        selectedList: selectedList,
        type: type,
        list: list,
        selectedReceiverData: selectedReceiverData,
        createLessonData: createLessonData,);
}

enum AcademicDetailType { affiliated, programme, classes, subjects, discipline }

class AcademicDetailsSelectionPagesState
    extends State<AcademicDetailsSelectionPages> {
  String? searchVal;
  GlobalKey<PaginatorState> paginatorKey = GlobalKey();
  List<AcademicDetailSelectionItem> itemsList = [];
  List<AcademicDetailSelectionItem>? selectedList;
  late TextStyleElements styleElements;
  AcademicDetailType? type;
  List<PostCreatePayload?>? list;
  PostReceiverListItem? selectedReceiverData;
  PostCreatePayload? createLessonData;

  AcademicDetailsSelectionPagesState(
      {List<AcademicDetailSelectionItem>? selectedList, this.type,this.list,this.selectedReceiverData,this.createLessonData}) {
    this.selectedList = selectedList ??= [];
  }

  void refresh() {
    itemsList.clear();
    paginatorKey.currentState!.changeState(resetState: true);
  }

  @override
  Widget build(BuildContext context) {
    styleElements = TextStyleElements(context);
    return SafeArea(
      child: Scaffold(
        appBar: TricycleAppBar().getCustomAppBarWithSearch(context,
            onSearchValueChanged: (value) {
              this.searchVal = value;
              refresh();
            },
            appBarTitle: getTitle(),
            onBackButtonPress: () {
              Navigator.pop(context);
            },
            actions: [
              TricycleTextButton(
                onPressed: () {
                  if (selectedList!.length > 0) {
                    if (type == AcademicDetailType.classes) {

                      for(int i=0;i<widget.list!.length;i++)
                      {
                        widget.list![i]!.classesList = List<Classes>.generate(
                            selectedList!.length, (int index){
                          return Classes(
                              classCode: selectedList![index].classCode,
                              id: selectedList![index].classId,
                              className: selectedList![index].className
                          );
                        }
                        );
                      }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return PostReceiverListPage(
                              list: widget.list,
                              callBack:(){
                                Navigator.of(context).pop();
                                if(widget.callBack!=null)
                                  widget.callBack!();
                              },
                              selectedReceiverData: selectedReceiverData,
                            );
                          }));
                    } else if (type == AcademicDetailType.programme) {


                      for(int i=0;i<widget.list!.length;i++)
                      {
                        widget.list![i]!.programmesList = List<Programme>.generate(
                            selectedList!.length, (int index){
                          return Programme(
                              programCode: selectedList![index].programCode,
                              id: selectedList![index].programId,
                              programName: selectedList![index].programName
                          );
                        }
                        );
                      }



                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return AcademicDetailsSelectionPages(
                              type: AcademicDetailType.discipline,
                              callBack:(){
                                Navigator.of(context).pop();
                                if(widget.callBack!=null)
                                  widget.callBack!();
                              },
                              selectedList: getSelectedList(AcademicDetailType.discipline),
                              list: widget.list,
                              selectedReceiverData: selectedReceiverData,
                            );
                          }));
                    } else if (type == AcademicDetailType.discipline) {


                      for(int i=0;i<widget.list!.length;i++)
                      {
                        widget.list![i]!.disciplineList = List<Discipline>.generate(
                            selectedList!.length, (int index){
                          return Discipline(
                              departmentCode: selectedList![index].departmentCode,
                              id: selectedList![index].departmentId,
                              departmentName: selectedList![index].departmentName
                          );
                        }
                        );
                      }


                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return AcademicDetailsSelectionPages(
                              type: AcademicDetailType.classes,
                              selectedList:getSelectedList(AcademicDetailType.classes),
                              category_type: 'college',
                              list: widget.list,
                              callBack:(){
                                Navigator.of(context).pop();
                                if(widget.callBack!=null)
                                  widget.callBack!();
                              },
                              selectedReceiverData: selectedReceiverData,
                            );
                          }));
                    } else {
                      Navigator.pop(context, selectedList);
                    }
                  } else {
                    ToastBuilder().showToast(
                        AppLocalizations.of(context)!
                            .translate('please_select_atleast'),
                        context,
                        HexColor(AppColors.failure));
                  }
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('next'),
                      style: styleElements
                          .subtitle2ThemeScalable(context)
                          .copyWith(color: HexColor(AppColors.appMainColor)),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: HexColor(AppColors.appMainColor))
                  ],
                ),
                shape: CircleBorder(),
              )
            ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left :16.0,bottom: 8.0),
            //   child: Text(
            //     widget.list[0]!=null &&widget.list[0].lessonTopic!=null&& widget.list[0].lessonTopic.title!=null ?widget.list[0].lessonTopic.title:  AppLocalizations.of(context).translate('topic_type'),
            //     style: styleElements
            //         .headline6ThemeScalable(context)
            //         .copyWith(fontWeight: FontWeight.bold),
            //   ),
            // ),

            Expanded(
              child: TricycleCard(
                child: Paginator<AcademicDetailsSelectionListResponse>.listView(
                  key: paginatorKey,
                  pageLoadFuture: fetchData,
                  pageItemsGetter: listItemGetter,
                  listItemBuilder: listItemBuilder,
                  loadingWidgetBuilder: CustomPaginator(context).loadingWidgetMaker,
                  errorWidgetBuilder: CustomPaginator(context).errorWidgetMaker,
                  emptyListWidgetBuilder: CustomPaginator(context).emptyListWidgetMaker,
                  totalItemsGetter: CustomPaginator(context).totalPagesGetter,
                  pageErrorChecker: CustomPaginator(context).pageErrorChecker,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AcademicDetailSelectionItem> getSelectedList(AcademicDetailType type) {
    if(type == AcademicDetailType.discipline) {
      if (createLessonData != null && createLessonData!.disciplineList != null &&
          createLessonData!.disciplineList!.length > 0) {
        return List<AcademicDetailSelectionItem>.generate(
            createLessonData!.disciplineList!.length, (index) {
          return AcademicDetailSelectionItem(
            departmentName: createLessonData!.disciplineList![index].departmentName,
            departmentCode: createLessonData!.disciplineList![index].departmentCode,
            departmentId: createLessonData!.disciplineList![index].id,
          );
        });
      } else {
        return [];
      }
    }else{
      if (createLessonData != null && createLessonData!.classesList != null &&
          createLessonData!.classesList!.length > 0) {
        return List<AcademicDetailSelectionItem>.generate(
            createLessonData!.classesList!.length, (index) {
          return AcademicDetailSelectionItem(
            className: createLessonData!.classesList![index].className,
            classCode: createLessonData!.classesList![index].classCode,
            classId: createLessonData!.classesList![index].id,
          );
        });
      } else {
        return [];
      }
    }
  }

  Future<AcademicDetailsSelectionListResponse> fetchData(int page) async {
    AcademicDetailsSelectionListRequest payload =
    AcademicDetailsSelectionListRequest();
    payload.pageNumber = page;
    payload.pageSize = 10;
    payload.searchVal = searchVal;
    payload.categoryType = widget.category_type;
    var val;
    if (type == AcademicDetailType.affiliated) {
      val = await Calls().call(
          jsonEncode(payload), context, Config.ACADEMIC_ORGANISATION_LIST);
    } else if (type == AcademicDetailType.programme) {
      payload.excludeType =['School'];
      val = await Calls()
          .call(jsonEncode(payload), context, Config.ACADEMIC_PROGRAM_LIST);
    } else if (type == AcademicDetailType.classes) {
      val = await Calls()
          .call(jsonEncode(payload), context, Config.ACADEMIC_CLASS_LIST);
    } else if (type == AcademicDetailType.discipline) {
      val = await Calls()
          .call(jsonEncode(payload), context, Config.ACADEMIC_DISCIPLINE_LIST);
    } else {
      val = await Calls()
          .call(jsonEncode(payload), context, Config.ACADEMIC_SUBJECT_LIST);
    }
    return AcademicDetailsSelectionListResponse.fromJson(val);
  }

  List<AcademicDetailSelectionItem>? listItemGetter(
      AcademicDetailsSelectionListResponse? pageData) {
    if (type == AcademicDetailType.affiliated) {
      pageData!.rows!.forEach((element) {
        if (selectedList!.any((elementSelected) {
          return elementSelected.organizationId == element.organizationId;
        })) {
          element.isSelected = true;
        }
      });
    } else if (type == AcademicDetailType.programme) {
      pageData!.rows!.forEach((element) {
        if (selectedList!.any((elementSelected) {
          return elementSelected.programId == element.programId;
        })) {
          element.isSelected = true;
        }
      });
    } else if (type == AcademicDetailType.classes) {
      pageData!.rows!.forEach((element) {
        if (selectedList!.any((elementSelected) {
          return elementSelected.classId == element.classId;
        })) {
          element.isSelected = true;
        }
      });
    } else if (type == AcademicDetailType.discipline) {
      pageData!.rows!.forEach((element) {
        if (selectedList!.any((elementSelected) {
          return elementSelected.departmentId == element.departmentId;
        })) {
          element.isSelected = true;
        }
      });
    } else {
      pageData!.rows!.forEach((element) {
        if (selectedList!.any((elementSelected) {
          return elementSelected.subjectId == element.subjectId;
        })) {
          element.isSelected = true;
        }
      });
    }
    itemsList.addAll(pageData.rows!);
    return pageData.rows;
  }

  Widget listItemBuilder(itemData, int index) {
    AcademicDetailSelectionItem item = itemData;
    return ListTile(
      onTap: () {
        onclick(item, index);
      },
      title: Text(
        getName(item)!,
        style: styleElements.subtitle1ThemeScalable(context),
      ),
      trailing: Checkbox(
        onChanged: (value) {
          onclick(item, index);
        },
        value: (item.isSelected != null && item.isSelected!),
      ),
      // trailing: Visibility(
      //   visible: (item.isSelected != null && item.isSelected),
      //   child: Icon(
      //     Icons.check_circle,
      //     color: HexColor(AppColors.appColorGreen),
      //     size: 20,
      //   ),
      // ),
    );
  }

  void onclick(AcademicDetailSelectionItem item, int index) {
    setState(() {
      if (item.isSelected != null && item.isSelected!) {
        itemsList[index].isSelected = false;
        var ind;
        if (type == AcademicDetailType.affiliated) {
          ind = selectedList!.indexWhere((element) {
            return element.organizationId == itemsList[index].organizationId;
          });
        } else if (type == AcademicDetailType.programme) {
          ind = selectedList!.indexWhere((element) {
            return element.programId == itemsList[index].programId;
          });
        } else if (type == AcademicDetailType.classes) {
          ind = selectedList!.indexWhere((element) {
            return element.classId == itemsList[index].classId;
          });
        } else if (type == AcademicDetailType.discipline) {
          ind = selectedList!.indexWhere((element) {
            return element.departmentId == itemsList[index].departmentId;
          });
        } else {
          ind = selectedList!.indexWhere((element) {
            return element.subjectId == itemsList[index].subjectId;
          });
        }
        selectedList!.removeAt(ind);
      } else {
        itemsList[index].isSelected = true;
        selectedList!.add(itemsList[index]);
      }
    });
  }

  String getTitle() {
    if (type == AcademicDetailType.affiliated) {
      return AppLocalizations.of(context)!.translate('select_affiliated_board');
    } else if (type == AcademicDetailType.programme) {
      return AppLocalizations.of(context)!.translate('select_programme');
    } else if (type == AcademicDetailType.classes) {
      return AppLocalizations.of(context)!.translate('select_class');
    } else if (type == AcademicDetailType.subjects) {
      return AppLocalizations.of(context)!.translate('select_subjects');
    } else if (type == AcademicDetailType.discipline) {
      return AppLocalizations.of(context)!.translate('select_discipline');
    } else {
      return "Select";
    }
  }

  String? getName(AcademicDetailSelectionItem item) {
    if (type == AcademicDetailType.affiliated) {
      return item.organizationName;
    } else if (type == AcademicDetailType.programme) {
      return item.programName;
    } else if (type == AcademicDetailType.classes) {
      return item.className;
    } else if (type == AcademicDetailType.discipline) {
      return item.departmentName;
    } else {
      return item.subjectName;
    }
  }
}
