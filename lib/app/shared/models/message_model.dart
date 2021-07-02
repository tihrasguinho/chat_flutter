class MessageModel {
  String id;
  String message;
  String sender;
  String receiver;
  int time;

  MessageModel({
    required this.id,
    required this.message,
    required this.sender,
    required this.receiver,
    required this.time,
  });
}
