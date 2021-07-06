import 'dart:async';
import 'dart:convert';

import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat/app/shared/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.friend,
    required this.uid,
  }) : super(key: key);

  final UserModel friend;
  final String uid;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var input = TextEditingController();

  late StreamSubscription<QuerySnapshot> subscription;

  late String currentUid;

  List<MessageModel> messages = <MessageModel>[];

  loadMessages() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    currentUid = map['uid'];

    var keyOne =
        base64UrlEncode(utf8.encode('${map['uid']}:${widget.friend.uid}'));

    var keyTwo =
        base64UrlEncode(utf8.encode('${widget.friend.uid}:${map['uid']}'));

    Query query = firebase.firestore.collection('chats');

    query = query.where('key', whereIn: [keyOne, keyTwo]);

    subscription = query.orderBy('time').snapshots().listen((event) {
      for (var item in event.docs) {
        var data = item.data() as Map<String, dynamic>;

        var message = {
          'id': item.id,
          ...data,
        };

        if (messages.every((e) => e.id != item.id)) {
          setState(() {
            messages.insert(0, MessageModel.fromMap(message));
          });
        }
      }
    });
  }

  void sendMessage() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    await firebase
        .sendMessageToFirestore(MessageModel(
      from: map['uid'],
      to: widget.friend.uid,
      message: input.text,
      type: 'text',
    ))
        .then((value) {
      input.clear();
      if (value is MessageModel) {
        if (messages.every((e) => e.id != value.id)) {
          setState(() {
            messages.insert(0, value);
          });
        }
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  void initState() {
    super.initState();
    loadMessages();
    initializeDateFormatting();
  }

  @override
  void dispose() {
    input.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        title: Text(widget.friend.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              physics: BouncingScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (_, i) {
                var item = messages[i];
                var isMe = item.from == currentUid;

                return buildBubble(context: context, item: item, isMe: isMe);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 5,
            ),
            child: Row(
              children: [
                Flexible(
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    elevation: 5,
                    child: TextField(
                      controller: input,
                      minLines: 1,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        border: InputBorder.none,
                        hintText: 'Escreva algo...',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Material(
                  borderRadius: BorderRadius.circular(90),
                  elevation: 5,
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      sendMessage();
                    },
                    splashColor: Colors.black12,
                    highlightColor: Colors.black12,
                    borderRadius: BorderRadius.circular(90),
                    child: SizedBox(
                      height: 52,
                      width: 52,
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildBubble({
    required BuildContext context,
    required MessageModel item,
    required bool isMe,
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
                      item.message,
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
      ],
    );
  }
}
