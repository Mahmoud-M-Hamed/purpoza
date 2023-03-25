class MessageModel {
  String? text, dateTime, receiverId;

  MessageModel({this.text, this.dateTime, this.receiverId});

  MessageModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    dateTime = json['dateTime'];
    receiverId = json['receiverId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'dateTime': dateTime,
      'receiverId': receiverId,
    };
  }
}
