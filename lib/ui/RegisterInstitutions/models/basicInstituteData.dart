class BasicData {
  String name;
  String description;
  String inst_cat_code;
  String inst_type_code;
  String profile_image;
  List<String> listOfNames;
  BasicData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    inst_cat_code = json['category'];

    listOfNames = json['other_names'].cast<String>();
    inst_type_code = json['type'];
    profile_image = json['profile_image'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['other_names'] = this.listOfNames;
    data['description'] = this.description;
    data['category'] = this.inst_cat_code;
    data['type'] = this.inst_type_code;
    data['profile_image'] = this.profile_image;

    return data;
  }

  BasicData({this.name, this.description, this.inst_cat_code,
    this.inst_type_code, this.profile_image,this.listOfNames});
}