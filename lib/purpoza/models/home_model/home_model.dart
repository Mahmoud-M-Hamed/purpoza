class HomeModel {
  String? userName, email, uId, coverImage, bio;
  String? profileImage;

  HomeModel({this.userName, this.email, this.uId, this.bio, this.coverImage});

  HomeModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    email = json['email'];
    uId = json['uId'];
    profileImage = (json['profileImage'] == null || json['profileImage'] == "")
        ? 'https://firebasestorage.googleapis.com'
            '/v0/b/purpoza-7cc87.appspot.com/o/assets%2FlocalImages%2Foip.jpg?'
            'alt=media&token=7790c0fa-9c4e-43b4-bc2d-b1206c9ad406'
        : json['profileImage'];
    coverImage = (json['coverImage'] == null || json['coverImage'] == "")
        ? 'https://firebasestorage.googleapis.com'
            '/v0/b/purpoza-7cc87.appspot.com/o/assets%2FlocalImages%2FblankCover.jpg?'
            'alt=media&token=4e57be4f-8104-46db-82fc-1fc68155b399'
        : json['coverImage'];
    bio = (json['bio'] == null || json['bio'] == "")
        ? 'write a bio...'
        : json['bio'];
  }
}
