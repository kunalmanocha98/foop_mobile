import 'package:oho_works_app/models/SubjectList.dart';


class SubjectItems {
  String? tittle;

  List<Subjects>? rows;


  SubjectItems({this.tittle, this.rows,});

  SubjectItems.fromJson(Map<String, dynamic> json) {

    tittle = json['tittle'];
    if (json['rows'] != null) {
      rows = [];//Subjects>();
      json['rows'].forEach((v) {
        rows!.add(new Subjects.fromJson(v));
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

