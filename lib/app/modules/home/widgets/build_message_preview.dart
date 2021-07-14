import 'package:chat/app/shared/functions/get_empty_image_url.dart';
import 'package:chat/app/shared/models/message_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

Widget buildMessagePreview(bool isMe, MessagePreview item) {
  var date = DateTime.fromMillisecondsSinceEpoch(item.message.time);
  var time = DateFormat.Hm('pt_BR').format(date);

  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 5,
    ),
    child: Material(
      color: Colors.white,
      elevation: 2,
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
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 15,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  item.sender.image!.isEmpty
                      ? getEmptyImageUrl(item.sender.name!.replaceAll(' ', '+'))
                      : item.sender.image!,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.sender.name!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.message.type == 'image'
                                ? 'Imagem'
                                : item.message.message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        isMe
                            ? Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.done_all_rounded,
                                  color: item.message.seen
                                      ? Colors.greenAccent
                                      : Colors.grey,
                                  size: 16,
                                ),
                              )
                            : item.message.seen
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.green,
                                      child: Text(
                                        '${item.unread}',
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                        SizedBox(width: 10),
                      ],
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
