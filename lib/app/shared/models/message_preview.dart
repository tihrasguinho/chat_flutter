import 'dart:convert';

import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/models/user_model.dart';

class MessagePreview {
  UserModel sender;
  MessageModel message;
  int unread;

  MessagePreview({
    required this.sender,
    required this.message,
    required this.unread,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender.toMap(),
      'message': message.toMap(),
      'unread': unread,
    };
  }

  factory MessagePreview.fromMap(Map<String, dynamic> map) {
    return MessagePreview(
      sender: UserModel.fromMap(map['sender']),
      message: MessageModel.fromMap(map['message']),
      unread: map['unread'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessagePreview.fromJson(String source) =>
      MessagePreview.fromMap(json.decode(source));
}
