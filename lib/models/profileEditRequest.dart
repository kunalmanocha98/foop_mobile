class ProfileEditPayload {
  String? firstName;
  String? secondName;
  String? lastName;
  int? gender;
  String? dateOfBirth;
  String? dateOfAnniversary;
  String? bloodGroup;
  String? slug;
  String? bio;
  String? quote;
  String? userName;
  String? designation;
  String? department;
  String? reportingManager;
  int? dateOfJoining;

  ProfileEditPayload(
      {this.firstName,
      this.secondName,
      this.lastName,
      this.gender,
        this.userName,
      this.dateOfBirth,
      this.dateOfAnniversary,
      this.bloodGroup,
      this.slug,
      this.bio,
        this.designation,
        this.department,
        this.reportingManager,
        this.dateOfJoining,
      this.quote});

  ProfileEditPayload.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    userName = json['user_name'];
    secondName = json['second_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    dateOfAnniversary = json['date_of_anniversary'];
    bloodGroup = json['blood_group'];
    slug = json['slug'];
    bio = json['bio'];
    quote = json['quote'];
    designation = json['designation'];
    department = json['department'];
    reportingManager = json['report_manager'];
    dateOfJoining = json['date_of_joining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['user_name']=this.userName;
    data['second_name'] = this.secondName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['date_of_anniversary'] = this.dateOfAnniversary;
    data['blood_group'] = this.bloodGroup;
    data['slug'] = this.slug;
    data['bio'] = this.bio;
    data['quote'] = this.quote;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['report_manager'] = this.reportingManager;
    data['date_of_joining'] = this.dateOfJoining;
    return data;
  }
}
