class BasicData {
  String? name;
  String? description;
  String? inst_cat_code;
  String? entity_type_code;
  String? profile_image;
  String ? employeeRange;
  List<String>? listOfNames;
  int ? businessId;
  BasicData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    businessId=json['business_id'];
    description = json['description'];
    inst_cat_code = json['category'];
    employeeRange = json['no_of_employees'];
    listOfNames = json['other_names'].cast<String>();
    entity_type_code = json['type'];
    profile_image = json['profile_image'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['business_id']=this.businessId;
    data['no_of_employees'] = this.employeeRange;
    data['other_names'] = this.listOfNames;
    data['description'] = this.description;
    data['category'] = this.inst_cat_code;
    data['type'] = this.entity_type_code;
    data['profile_image'] = this.profile_image;

    return data;
  }

  BasicData({this.name, this.description, this.inst_cat_code,
    this.entity_type_code, this.profile_image,this.listOfNames});
}