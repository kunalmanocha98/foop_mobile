class RequestCallBack {
  String enquiryType;
  String firstName;
  String lastName;
  String mobileNumber;
  String emailId;
  String enquiryDetails;
  String enquirySource;
  String institutionName;
  InstitutionLocation institutionLocation;
  String enquiryReference;
  String numberOfStudent;
  String numberOfTeacher;
  String institutionType;
  String relationShipType;
  String description;

  RequestCallBack(
      {this.enquiryType,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.emailId,
        this.enquiryDetails,
        this.enquirySource,
        this.institutionName,
        this.institutionLocation,
        this.enquiryReference,
        this.numberOfStudent,
        this.numberOfTeacher,
        this.institutionType,
        this.relationShipType,
        this.description});

  RequestCallBack.fromJson(Map<String, dynamic> json) {
    enquiryType = json['enquiry_type'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    emailId = json['email_id'];
    enquiryDetails = json['enquiry_details'];
    enquirySource = json['enquiry_source'];
    institutionName = json['institution_name'];
    institutionLocation = json['institution_location'] != null
        ? new InstitutionLocation.fromJson(json['institution_location'])
        : null;
    enquiryReference = json['enquiry_reference'];
    numberOfStudent = json['number_of_student'];
    numberOfTeacher = json['number_of_teacher'];
    institutionType = json['institution_type'];
    relationShipType = json['relation_ship_type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enquiry_type'] = this.enquiryType;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['email_id'] = this.emailId;
    data['enquiry_details'] = this.enquiryDetails;
    data['enquiry_source'] = this.enquirySource;
    data['institution_name'] = this.institutionName;
    if (this.institutionLocation != null) {
      data['institution_location'] = this.institutionLocation.toJson();
    }
    data['enquiry_reference'] = this.enquiryReference;
    data['number_of_student'] = this.numberOfStudent;
    data['number_of_teacher'] = this.numberOfTeacher;
    data['institution_type'] = this.institutionType;
    data['relation_ship_type'] = this.relationShipType;
    data['description'] = this.description;
    return data;
  }
}

class InstitutionLocation {
  String address1;
  String address2;
  String city;
  String district;
  String pincode;
  String lat;
  String long;

  InstitutionLocation(
      {this.address1,
        this.address2,
        this.city,
        this.district,
        this.pincode,
        this.lat,
        this.long});

  InstitutionLocation.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    district = json['district'];
    pincode = json['pincode'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['district'] = this.district;
    data['pincode'] = this.pincode;
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}
