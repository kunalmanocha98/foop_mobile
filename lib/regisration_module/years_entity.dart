class YearsData {

  bool? isSelected=false;
  String? yearName;


  YearsData({this.yearName,this.isSelected});

  YearsData.fromJson(Map<String, dynamic> json) {
    isSelected = json['isSelected'];
    yearName = json['yearName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['yearName'] = this.yearName;
    data['isSelected'] = this.isSelected;

    return data;
  }
}