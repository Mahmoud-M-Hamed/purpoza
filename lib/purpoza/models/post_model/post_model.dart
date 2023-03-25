class PostModel {
  String? userName, email, uId, userImage, postText, dateTime, postImage;

  PostModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    email = json['email'];
    uId = json['uId'];
    userImage = (json['userImage'] == null || json['userImage'] == "")
        ? 'https://firebasestorage.googleapis.com'
            '/v0/b/purpoza-7cc87.appspot.com/o/assets%2FlocalImages%2Foip.jpg?'
            'alt=media&token=7790c0fa-9c4e-43b4-bc2d-b1206c9ad406'
        : json['userImage'];
    postText = json['postText'];
    postImage = json['postImage'] ??= '';
    dateTime = json['dateTime'];
  }
}
