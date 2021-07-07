import 'package:chat/app/shared/models/message_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

Widget buildMessagePreview(bool isMe, MessagePreview item) {
  var date = DateTime.fromMillisecondsSinceEpoch(item.message.time!);
  var time = DateFormat.Hm('pt_BR').format(date);

  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 5,
    ),
    child: Material(
      color: Colors.white,
      elevation: 5,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: () => Modular.to.pushNamed(
          '/home/chat/${item.sender.uid}',
          arguments: {
            'friend': item.sender,
          },
        ),
        splashColor: Colors.black12,
        highlightColor: Colors.black12,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isMe ? 'Você' : item.sender.name!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      item.message.message!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black45,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    ),
  );
}
