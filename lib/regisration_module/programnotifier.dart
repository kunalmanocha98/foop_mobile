import 'dart:convert';

import 'package:oho_works_app/api_calls/calls.dart';
import 'package:oho_works_app/models/program_data.dart';
import 'package:oho_works_app/utils/config.dart';
import 'package:oho_works_app/utils/strings.dart';
import 'package:flutter/material.dart';

class ProgramNotifier extends ChangeNotifier {
  int _pageNumber = 1;
  List<ProgramDataItem>? _listConversations;
  Map? mapItems;

  Future<void> reload(String? searchVal, int? instituteId, BuildContext context,
      List<Programs> _listSelectedPrograms) async {
    _listConversations = <ProgramDataItem>[];
    _pageNumber = 1;
    await getConversations(_pageNumber, searchVal, instituteId, context,
        _listSelectedPrograms);
  }

  Future<void> search(String? searchVal, int? instituteId, BuildContext context,
     List<Programs> _listSelectedPrograms) async {
    _listConversations = <ProgramDataItem>[];
    _pageNumber = 1;

    await getConversations(_pageNumber, searchVal, instituteId, context,
        _listSelectedPrograms);
  }

  Future<void> getMore(String? searchVal, int? instituteId, BuildContext context,
      List<Programs> _listSelectedPrograms) async {
    await getConversations(_pageNumber, searchVal, instituteId, context,
        _listSelectedPrograms);
  }

  List<ProgramDataItem>? getConversationList() {
    return _listConversations;
  }

  Future<void> getSearchedList( String search) async {
    _listConversations ??= <ProgramDataItem>[];
    // _listConversations = await db.searchedList(search);

    notifyListeners();
  }

  Future<void> getConversations(
      int page,
      String? searchVal,
      int? instituteId,
      BuildContext context,

      List<Programs> _listSelectedPrograms) async {
    _listConversations ??= <ProgramDataItem>[];
    int pageNumber = page;
    final body = jsonEncode({
      "institution_id": instituteId,
      "search_val": searchVal,
      "page_number": page,
      "page_size": 10
    });
    Calls().call(body, context, Config.PROGRAM_LIST).then((v) async {
      if (v != null) {
        var data = ProgramsData.fromJson(v);
        if (data != null && data.statusCode == Strings.success_code) {
          if (data.rows!.isNotEmpty) {
            pageNumber++;
            _pageNumber = pageNumber;

            _listConversations!.addAll(data.rows!);
            if (_listSelectedPrograms != null &&
                _listSelectedPrograms.isNotEmpty) {
              for (var item in _listSelectedPrograms) {
                if (item.isSelected!) {
                  for (int i = 0; i < _listConversations!.length; i++) {
                    for (int j = 0;
                        j < _listConversations![i].programs!.length;
                        j++) {
                      if (_listConversations![i].programs![j].id == item.id) {
                        _listConversations![i].programs![j].isSelected = true;
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

  updateItem(Programs pr, String degreeType, bool isSelected, bool isTeacher) {
    for (int i = 0; i < _listConversations!.length; i++) {
      for (int j = 0; j < _listConversations![i].programs!.length; j++) {
        if (pr.programCode == _listConversations![i].programs![j].programCode) {
          _listConversations![i].programs![j].isSelected = isSelected;
        } else {
          if (!isTeacher) _listConversations![i].programs![j].isSelected = false;
        }
      }
    }

    notifyListeners();
  }
}
