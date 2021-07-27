import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/department_data.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';


class DisciplineNotifier extends ChangeNotifier {
  int _pageNumber = 1;
  List<DepartmentItems>? _listConversations;

  Future<void> reload(String? searchVal,int? instituteId,BuildContext context,List<Departments> _listDepartmentSelected) async {
    _listConversations = <DepartmentItems>[];
    _pageNumber = 1;
    await getConversations(_pageNumber,searchVal,instituteId,context,_listDepartmentSelected);
  }

  Future<void> search(String? searchVal,int? instituteId,BuildContext context,List<Departments> _listDepartmentSelected) async {
    _listConversations = <DepartmentItems>[];
    _pageNumber = 1;

    await getConversations(_pageNumber,searchVal,instituteId,context,_listDepartmentSelected);
  }
  Future<void> getMore(String? searchVal,int? instituteId,BuildContext context ,List<Departments> _listDepartmentSelected) async {
    await getConversations(_pageNumber,searchVal,instituteId,context,_listDepartmentSelected);
  }
  List<DepartmentItems>? getConversationList() {
    return _listConversations;
  }

  Future<void> getSearchedList(DatabaseHelper db,String search) async {
    _listConversations ??= <DepartmentItems>[];
    // _listConversations = await db.searchedList(search);

    notifyListeners();
  }
  Future<void> getConversations(int page,String? searchVal,int? instituteId,BuildContext context, List<Departments> _listDepartmentSelected) async {
    _listConversations ??= <DepartmentItems>[];
    int pageNumber = page;
    final body = jsonEncode({
      "institution_id":instituteId,
      "search_val": searchVal,
      "page_number": page,
      "page_size": 50
    });
    Calls()
        .call(body, context,
        Config.DEPARTMENT_LIST)
        .then((v) async {
      if (v != null) {
        var data = DepartmentResponse.fromJson(v);
        if (data != null && data.statusCode == Strings.success_code) {
          if (data.rows!.isNotEmpty) {
            pageNumber++;
            _pageNumber = pageNumber;
            _listConversations!.addAll(data.rows!);
            if (_listDepartmentSelected != null &&
                _listDepartmentSelected.isNotEmpty) {
              for (var item in _listDepartmentSelected) {
                if (item.isSelected!) {
                  for (int i = 0; i < _listConversations!.length; i++) {
                    for (int j = 0;
                    j < _listConversations![i].departments!.length;
                    j++) {
                      if (_listConversations![i].departments![j].id == item.id) {
                        _listConversations![i].departments![j].isSelected = true;
                      }
                    }
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

  updateItem(Departments pr, String degreeType, bool isSelected,bool isTeacher) {
    for (int i = 0; i < _listConversations!.length; i++) {
      for (int j = 0; j < _listConversations![i].departments!.length; j++) {
        if (pr.departmentCode == _listConversations![i].departments![j].departmentCode) {
          _listConversations![i].departments![j].isSelected = isSelected;
        }
        else
        {
          if(!isTeacher)
            _listConversations![i].departments![j].isSelected = false;
        }

      }
    }

    notifyListeners();
  }

}
