import 'package:chat/app/shared/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildBubble({
  required BuildContext context,
  required MessageModel item,
  required bool isMe,
  Function? onPress,
  Function? onLongPress,
  Function? onDoubleTap,
}) {
  var date = DateTime.fromMillisecondsSinceEpoch(item.time!);
  var time = DateFormat.Hm('pt_BR').format(date);

  return Row(
    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(
          right: isMe ? 8 : 50,
          left: isMe ? 50 : 8,
          top: 0,
          bottom: 8,
        ),
        child: Material(
          color: isMe ? Theme.of(context).primaryColor : Colors.white,
          elevation: 5,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
            topLeft: Radius.circular(isMe ? 8 : 0),
            topRight: Radius.circular(isMe ? 0 : 8),
          ),
          child: InkWell(
            onTap: () => onPress!(),
            onLongPress: () => onLongPress!(),
            onDoubleTap: () => onDoubleTap!(),
            splashColor: Colors.black12,
            highlightColor: Colors.black12,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(isMe ? 8 : 0),
              topRight: Radius.circular(isMe ? 0 : 8),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                right: isMe ? 8 : 10,
                left: isMe ? 10 : 8,
                bottom: 5,
                top: 3,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      right: isMe ? 30 : 0,
                      left: isMe ? 0 : 30,
                    ),
                    child: Text(
                      item.message!,
                      style: TextStyle(
                        fontSize: 16,
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    '$time',
                    style: TextStyle(
                      fontSize: 8,
                      color: isMe ? Colors.white54 : Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
