class SignUpModel {
  String? userName;
  String? phoneNumber;
  String? uId;
  String? email, password;
  String? profileImage, coverImage, bio;

  SignUpModel({
    this.userName,
    this.uId,
    this.phoneNumber,
    this.email,
    this.password,
    this.profileImage,
    this.coverImage,
    this.bio,
  });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    uId = json['uId'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'phoneNumber': phoneNumber,
      'uId': uId,
      'email': email,
      'password': password,
      'profileImage': profileImage ?? '',
      'coverImage': coverImage ?? '',
      'bio': bio ?? '',
    };
  }
}
