class ChildDetailRequest {
  int parentAllPersonsId;
  int allInstitutionId;
  String institutionClassId;
  String institutionSectionId;
  String childFullName;
  String dateOfBirth;
  String admissionNo;
  String email;
  String phoneNumber;
  String mobileNumber;
  int invitationId;
  String gender;

  ChildDetailRequest(
      {this.parentAllPersonsId,
        this.allInstitutionId,
        this.institutionClassId,
        this.institutionSectionId,
        this.childFullName,
        this.dateOfBirth,
        this.admissionNo,
        this.email,
        this.phoneNumber,
        this.mobileNumber,
        this.gender,
        this.invitationId});

  ChildDetailRequest.fromJson(Map<String, dynamic> json) {
    parentAllPersonsId = json['parent_all_persons_id'];
    allInstitutionId = json['all_institution_id'];
    institutionClassId = json['institution_class_id'];
    institutionSectionId = json['institution_section_id'];
    childFullName = json['child_full_name'];
    dateOfBirth = json['date_of_birth'];
    admissionNo = json['admission_no'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    mobileNumber = json['mobile_number'];
    invitationId = json['invitation_id'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parent_all_persons_id'] = this.parentAllPersonsId;
    data['all_institution_id'] = this.allInstitutionId;
    data['institution_class_id'] = this.institutionClassId;
    data['institution_section_id'] = this.institutionSectionId;
    data['child_full_name'] = this.childFullName;
    data['date_of_birth'] = this.dateOfBirth;
    data['admission_no'] = this.admissionNo;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['invitation_id'] = this.invitationId;
    data['gender'] = this.gender;
    return data;
  }
}



class ChildDetailResponse {
  String statusCode;
  String message;
  ChildDetailRequest rows;
  int total;

  ChildDetailResponse({this.statusCode, this.message, this.rows, this.total});

  ChildDetailResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new ChildDetailRequest.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}