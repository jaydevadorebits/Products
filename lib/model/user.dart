class UserModel {
  String? userId;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  String? gender;
  String? dob;

  UserModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.gender,
      this.dob});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.userId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['dob'] = this.dob;

    return data;
  }
}
