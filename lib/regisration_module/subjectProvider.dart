import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/subject_response.dart';
import 'package:oho_works_app/app_database/data_base_helper.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';


class SubjectsProvider extends ChangeNotifier {
  int _pageNumber = 1;
  List<SubjectItems>? _listConversations;

  Future<void> reload(String? searchVal,int? instituteId,BuildContext context) async {
    _listConversations = <SubjectItems>[];
    _pageNumber = 1;
    await getConversations(_pageNumber,searchVal,instituteId,context);
  }

  Future<void> search(String? searchVal,int? instituteId,BuildContext context) async {
    _listConversations = <SubjectItems>[];
    _pageNumber = 1;
    await getConversations(_pageNumber,searchVal,instituteId,context);
  }
  Future<void> getMore(String? searchVal,int? instituteId,BuildContext context) async {
    await getConversations(_pageNumber,searchVal,instituteId,context);
  }
  List<SubjectItems>? getConversationList() {
    return _listConversations;
  }

  Future<void> getSearchedList(DatabaseHelper db,String search) async {
    _listConversations ??= <SubjectItems>[];
    // _listConversations = await db.searchedList(search);

    notifyListeners();
  }
  Future<void> getConversations(int page,String? searchVal,int? instituteId,BuildContext context) async {
    _listConversations ??= <SubjectItems>[];
    int pageNumber = page;
    final body = jsonEncode({
      "institution_id":instituteId,
      "search_val": searchVal,
      "page_number": page,
      "page_size": 50
    });
    Calls()
        .call(body, context,
        Config.SUBJECT_LIST)
        .then((v) async {
      if (v != null) {
        var data = SubjectResponse.fromJson(v);
        if (data != null && data.statusCode == Strings.success_code) {
          if (data.rows!.isNotEmpty) {
            pageNumber++;
            _pageNumber = pageNumber;
            _listConversations!.addAll(data.rows!);
            notifyListeners();

          }
        }
      } else {}
    }).catchError((onError) {});
  }
  updateItem(Subjects pr, String degreeType, bool isSelected,bool isTeacher) {
    for (int i = 0; i < _listConversations!.length; i++) {
      for (int j = 0; j < _listConversations![i].subjects!.length; j++) {
        if (pr.subjectCode == _listConversations![i].subjects![j].subjectCode) {
          _listConversations![i].subjects![j].isSelected = isSelected;
        }
        else
        {
          if(!isTeacher)
            _listConversations![i].subjects![j].isSelected = false;
        }

      }
    }

    notifyListeners();
  }


}
