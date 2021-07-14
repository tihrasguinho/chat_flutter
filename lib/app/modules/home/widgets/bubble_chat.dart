import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/modules/home/stores/chat_store.dart';
import 'package:chat/app/shared/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart' as intl;

class BubbleChat extends StatefulWidget {
  const BubbleChat({
    Key? key,
    required this.isMe,
    required this.item,
    this.onLongPress,
    this.onDoubleTap,
    this.onSwiped,
    this.onImagePressed,
    this.onPressed,
  }) : super(key: key);

  final bool isMe;
  final MessageModel item;
  final Function? onPressed;
  final Function? onImagePressed;
  final Function? onLongPress;
  final Function? onDoubleTap;
  final Function(MessageModel)? onSwiped;

  @override
  _BubbleChatState createState() => _BubbleChatState();
}

class _BubbleChatState extends State<BubbleChat> {
  final ChatStore chat = Modular.get();
  final HomeStore home = Modular.get();

  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(widget.item.time);
    var time = intl.DateFormat.Hm('pt_BR').format(date);

    var isImage = widget.item.type == 'image';

    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          right: widget.isMe ? 5 : 100,
          left: widget.isMe ? 100 : 5,
          bottom: 5,
        ),
        child: InkWell(
          onTap: isImage ? null : () => widget.onPressed!(),
          onLongPress: isImage ? null : () => widget.onLongPress!(),
          onDoubleTap: isImage ? null : () => widget.onDoubleTap!(),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(widget.isMe ? 12 : 2),
            bottomRight: Radius.circular(widget.isMe ? 2 : 12),
          ),
          child: Material(
            elevation: 2,
            color: widget.isMe ? Theme.of(context).primaryColor : Colors.white,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(widget.isMe ? 12 : 2),
              bottomRight: Radius.circular(widget.isMe ? 2 : 12),
            ),
            child: isImage
                ? Column(
                    children: [
                      Stack(
                        children: [
                          InkWell(
                              onTap: () => widget.onImagePressed!(),
                              onLongPress: () => widget.onLongPress!(),
                              onDoubleTap: () => widget.onDoubleTap!(),
                              child: Image.network(widget.item.message)),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Row(
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: widget.isMe
                                        ? Colors.white54
                                        : Colors.black54,
                                  ),
                                ),
                                widget.isMe
                                    ? Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Icon(
                                          Icons.done_all_rounded,
                                          size: 14,
                                          color: widget.item.seen
                                              ? Colors.greenAccent
                                              : Colors.white54,
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: SelectableText(
                            !isImage ? widget.item.message : '',
                            style: TextStyle(
                              fontSize: 16,
                              color: widget.isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                widget.isMe ? Colors.white54 : Colors.black54,
                          ),
                        ),
                        widget.isMe
                            ? Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.done_all_rounded,
                                  size: 14,
                                  color: widget.item.seen
                                      ? Colors.greenAccent
                                      : Colors.white54,
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
