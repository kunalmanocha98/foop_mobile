import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/RegisterUserAs.dart';
import 'package:oho_works_app/models/classes_sections.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';

class ClassesAndSectionsProvider extends ChangeNotifier {
  int _pageNumber = 1;
  List<ClassesWithSection>? _listConversations;

  Future<void> reload(String? searchVal,int? instituteId,BuildContext context,List<PersonClasses> _listSelectedClasses) async {
    _listConversations = <ClassesWithSection>[];
    _pageNumber = 1;
    await getConversations(_pageNumber,searchVal,instituteId,context,_listSelectedClasses);
  }

  Future<void> search(String? searchVal,int? instituteId,BuildContext context,List<PersonClasses> _listSelectedClasses) async {
    _listConversations = <ClassesWithSection>[];
    _pageNumber = 1;

    await getConversations(_pageNumber,searchVal,instituteId,context,_listSelectedClasses);
  }
  Future<void> getMore(String? searchVal,int? instituteId,BuildContext context,List<PersonClasses> _listSelectedClasses) async {
    await getConversations(_pageNumber,searchVal,instituteId,context,_listSelectedClasses);
  }
  List<ClassesWithSection>? getConversationList() {
    return _listConversations;
  }

  Future<void> getSearchedList(DatabaseHelper db,String search) async {
    _listConversations ??= <ClassesWithSection>[];
    // _listConversations = await db.searchedList(search);

    notifyListeners();
  }
  Future<void> getConversations(int page,String? searchVal,int? instituteId,BuildContext context,List<PersonClasses> _listSelectedClasses) async {
    _listConversations ??= <ClassesWithSection>[];
    int pageNumber = page;
    final body = jsonEncode({
      "business_id":instituteId,
      "search_val": searchVal,
      "page_number": page,
      "page_size": 10
    });
    Calls()
        .call(body, context,
        Config.CLASSES_SECTIONS)
        .then((v) async {
      if (v != null) {
        var data = ClassesAndSectionResponse.fromJson(v);
        if (data != null && data.statusCode == Strings.success_code) {
          if (data.rows!.isNotEmpty) {
            pageNumber++;_pageNumber = pageNumber;

            for (var item in data.rows!)
              {
                Sections sections = Sections(
                    id: 0,
                    isSelected: false,
                    sectionName: "More",
                    sectionDescription: item.className);
                if(item.sections!.length>4)
                item.sections!.insert(3, sections);

              }

            _listConversations!.addAll(data.rows!);

            if (_listSelectedClasses != null &&
                _listSelectedClasses.isNotEmpty) {
              for (var item in _listSelectedClasses) {

                for (int i = 0; i < _listConversations!.length; i++) {
                  if(item.classId==_listConversations![i].id)
                    {
                      for (var section in item.sections!)

                      {for (int j = 0; j < _listConversations![i].sections!.length; j++) {
                        if (section == _listConversations![i].sections![j].id) {
                          _listConversations![i].sections![j].isSelected = true;
                        }


                      }}

                    }

                }

              }
            }
            notifyListeners();
          }
        }
      } else {}
    }).catchError((onError) {});
  }
  updateItem(Sections pr, String degreeType, bool isSelected,bool isTeacher) {
    for (int i = 0; i < _listConversations!.length; i++) {
      for (int j = 0; j < _listConversations![i].sections!.length; j++) {
        if (pr.id == _listConversations![i].sections![j].id) {
          _listConversations![i].sections![j].isSelected = isSelected;
        }
        else
        {
          if(_listConversations![i].sections![j].sectionName=="More"||_listConversations![i].sections![j].sectionName=="Less")
            {}
          else
            {
              if(!isTeacher)
                _listConversations![i].sections![j].isSelected = false;
            }
        }

      }
    }

    notifyListeners();
  }

  updateItemMoreLess(String? className,bool isSelected) {
    for (int i = 0; i < _listConversations!.length; i++) {
     if(_listConversations![i].className==className)
       {
         for (int j = 0; j < _listConversations![i].sections!.length; j++) {
           if ( _listConversations![i].sections![j].sectionDescription==className)
             {
              if(isSelected)
                _listConversations![i].sections![j].sectionName="Less";
              else
                _listConversations![i].sections![j].sectionName="More";
               _listConversations![i].sections![j].isSelected = isSelected;
             }
         }

       }
    }

    notifyListeners();
  }




}
