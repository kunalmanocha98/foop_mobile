

import 'classes_sections_data.dart';

class ClassesAndSectionsItem {
  String? tittle;

  List<ClassesAndSections>? rows;


  ClassesAndSectionsItem({this.tittle, this.rows,});

  ClassesAndSectionsItem.fromJson(Map<String, dynamic> json) {

    tittle = json['tittle'];
    if (json['rows'] != null) {
      rows = [];//ClassesAndSections>();
      json['rows'].forEach((v) {
        rows!.add(new ClassesAndSections.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['tittle'] = this.tittle;
    return data;
  }
}

