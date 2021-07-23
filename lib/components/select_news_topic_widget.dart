import 'package:oho_works_app/components/customcard.dart';
import 'package:oho_works_app/components/tricycleavatar.dart';
import 'package:oho_works_app/enums/resolutionenums.dart';
import 'package:oho_works_app/enums/serviceTypeEnums.dart';
import 'package:oho_works_app/models/base_res.dart';
import 'package:oho_works_app/models/post/post_sub_type_list.dart';
import 'package:oho_works_app/ui/postModule/campusNewsHelperPages.dart';
import 'package:oho_works_app/ui/postModule/subject_list_select.dart';
import 'package:oho_works_app/utils/TextStyles/TextStyleElements.dart';
import 'package:oho_works_app/utils/colors.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/hexColors.dart';
import 'package:oho_works_app/utils/utility_class.dart';
import 'package:flutter/material.dart';

class SelectNewsTopicWidget extends StatefulWidget {
  final bool isCard;
  final String? type;

  SelectNewsTopicWidget(Key key, {this.isCard = true, this.type})
      : super(key: key);

  @override
  SelectNewsTopicWidgetState createState() => SelectNewsTopicWidgetState();
}

class SelectNewsTopicWidgetState extends State<SelectNewsTopicWidget> {
  List<PostSubTypeListItem> _selectedList = [];
  List<SubRow> subjectList = [];

  @override
  Widget build(BuildContext context) {
    var styleElements = TextStyleElements(context);
    return widget.isCard
        ? TricycleCard(
      margin: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
      onTap: () {
        if (widget.type != 'subject') {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return CampusNewsHelperPages(
                  CAMPUS_NEWS_TYPE.topics,
                  selectedList: _selectedList,
                  selectedReceiverData: null,
                );
              })).then((value) {
            if (value != null) {
              setState(() {
                _selectedList = value;
              });
            }
          });
        }
        else {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return SubjectTopicSelect(selectedList: subjectList);
              })).then((value) {
            if (value != null) {
              setState(() {
                if (value != null) {
                  subjectList = value;
                }
              });
            }
          });
        }
      },
      child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: TricycleAvatar(
            key: UniqueKey(),
            size: 36,
            isFullUrl: _selectedList.length > 0,
            imageUrl: getImageUrl(),
          ),
          title: Text(
            getTitle()!,
            style: styleElements.subtitle1ThemeScalable(context),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: HexColor(AppColors.appColorBlack35),
            size: 20,
          )),
    )
        : Container(
        margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        child: GestureDetector(
          onTap: () {
            if (widget.type != 'subject') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return CampusNewsHelperPages(
                      CAMPUS_NEWS_TYPE.topics,
                      selectedList: _selectedList,
                      selectedReceiverData: null,
                    );
                  })).then((value) {
                if (value != null) {
                  setState(() {
                    _selectedList = value;
                  });
                }
              });
            }
            else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return SubjectTopicSelect(selectedList: subjectList);
                  })).then((value) {
                if (value != null) {
                  setState(() {
                    if (value != null) {
                      subjectList = value;
                    }
                  });
                }
              });
            }
          },
          child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: (widget.type != 'subject')
                  ? TricycleAvatar(
                key: UniqueKey(),
                size: 36,
                isFullUrl:
                _selectedList != null && _selectedList.length > 0,
                imageUrl: getImageUrl(),
              )
                  : null,
              title: Text(
                getTitle()!,
                style: styleElements.subtitle1ThemeScalable(context),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: HexColor(AppColors.appColorBlack35),
                size: 20,
              )),
        ));
  }

  String? getTitle() {
    if (widget.type != 'subject') {
      if (_selectedList != null && _selectedList.length > 0) {
        if (_selectedList.length > 1) {
          return _selectedList[0].postSubTypeName! + ' & Others';
        } else {
          return _selectedList[0].postSubTypeName;
        }
      } else {
        return 'Select topics';
      }
    } else {
      if (subjectList != null && subjectList.length > 0) {
        if (subjectList.length > 1) {
          return subjectList[0].textOne! + ' & Others';
        } else {
          return subjectList[0].textOne;
        }
      } else {
        return 'Select subjects';
      }
    }
  }

  String getImageUrl() {
    if (_selectedList != null && _selectedList.length > 0) {
      debugPrint(Config.BASE_URL + _selectedList[0].imageUrl!);
      return Config.BASE_URL + _selectedList[0].imageUrl!;
    } else {
      return Utility()
          .getUrlForImage('', RESOLUTION_TYPE.R64, SERVICE_TYPE.SUBJECT);
    }
  }

  List<String?> getSelectedList() {
    List<String?> list = [];
    _selectedList.forEach((element) {
      list.add(element.postSubTypeName);
    });
    return list;
  }

  List<String?> getSubjects() {
    List<String?> list = [];
    subjectList.forEach((element) {
      list.add(element.textOne);
    });
    return list;
  }
}
