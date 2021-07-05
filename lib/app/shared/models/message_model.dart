import 'dart:convert';

class MessageModel {
  String? id;
  String from;
  String to;
  String message;
  String type;
  String? key;
  int? time;
  int? updated;

  MessageModel({
    this.id,
    required this.from,
    required this.to,
    required this.message,
    required this.type,
    this.key,
    this.time,
    this.updated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'message': message,
      'type': type,
      'key': key,
      'time': time,
      'updated': updated,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      from: map['from'],
      to: map['to'],
      message: map['message'],
      type: map['type'],
      key: map['key'],
      time: map['time'],
      updated: map['updated'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));
}

enum MessageType { text, image, audio, video, document }
