class UserContact {
  int? id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? mobileNumber;
  int? isSync;
  int? isSelected;
  UserContact({this.name, this.mobileNumber, this.id, this.isSync});

  UserContact.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    name = json['name'];
    isSelected = json['isSelected'];
    id = json['_id'];
    isSync = json['isSync'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['name'] = this.name;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.id;
    data['isSync'] = this.isSync;
    data['mobileNumber'] = this.mobileNumber;
    return data;
  }
}
