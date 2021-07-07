import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? id;
  String? from;
  String? to;
  String? message;
  String? type;
  String? key;
  bool? seen;
  int? time;
  int? updated;

  MessageModel({
    this.id,
    this.from,
    this.to,
    this.message,
    this.type,
    this.key,
    this.seen,
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
      'seen': seen,
      'time': time,
      'updated': updated,
    };
  }

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return MessageModel.fromMap({...data, 'id': doc.id});
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      from: map['from'],
      to: map['to'],
      message: map['message'],
      type: map['type'],
      key: map['key'],
      seen: map['seen'],
      time: map['time'],
      updated: map['updated'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));
}

enum MessageType { text, image, audio, video, document }
