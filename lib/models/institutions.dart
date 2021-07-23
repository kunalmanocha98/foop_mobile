class Institutions {
int? id;
String? name;
String? role;

Institutions({this.id, this.name, this.role});

Institutions.fromJson(Map<String, dynamic> json) {
id = json['id'];
name = json['name'];
role = json['role'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['name'] = this.name;
  data['role'] = this.role;
  return data;
}
}