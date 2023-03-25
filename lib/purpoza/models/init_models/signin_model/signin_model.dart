class SignInModel {
  String? email;
  String? password;
  String? uId;

  SignInModel({required this.email, required this.password});

  SignInModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    uId = json['uId'];
  }
}
