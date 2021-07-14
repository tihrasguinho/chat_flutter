import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageModel {
  String? id;
  String from;
  String to;
  String message;
  String type;
  String? key;
  String? replyId;
  bool seen;
  int time;
  int? updated;

  MessageModel({
    this.id,
    required this.from,
    required this.to,
    required this.message,
    required this.type,
    this.key,
    this.replyId,
    required this.seen,
    required this.time,
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
      'replyId': replyId,
      'seen': seen,
      'time': time,
      'updated': updated,
    };
  }

  factory MessageModel.fromDatabase(DataSnapshot snapshot) {
    return MessageModel(
      id: snapshot.key,
      from: snapshot.value['from'],
      to: snapshot.value['to'],
      message: snapshot.value['message'],
      type: snapshot.value['type'],
      seen: snapshot.value['seen'],
      time: snapshot.value['time'],
    );
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
      replyId: map['replyId'],
      seen: map['seen'],
      time: map['time'],
      updated: map['updated'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageModel(id: $id, from: $from, to: $to, message: $message, type: $type, key: $key, replyId: $replyId, seen: $seen, time: $time, updated: $updated)';
  }
}

enum MessageType { text, image, audio, video, document }
