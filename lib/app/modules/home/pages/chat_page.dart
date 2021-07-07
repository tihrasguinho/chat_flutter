import 'dart:async';

import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/modules/home/widgets/build_bubble.dart';
import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  final HomeStore store = Modular.get();

  List<MessageModel> messages = <MessageModel>[];

  late StreamSubscription<QuerySnapshot> subscription;

  var input = TextEditingController();

  _deleteOnFirestore(MessageModel message) async {
    await firebase.firestore
        .collection('chats')
        .doc(message.id)
        .delete()
        .then((_) {
      setState(() {
        messages.removeWhere((e) => e.id == message.id);
      });
      Modular.to.pop();
    }).catchError((err) {
      print(err);
    });
  }

  void deleteMessage(BuildContext context, MessageModel item) async {
    await showDialog(
      context: context,
      builder: (_) {
        return Center(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  right: 15,
                  left: 15,
                ),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  elevation: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Text(
                          'Deseja apagar esta mensagem?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Material(
                        color: Theme.of(context).primaryColor,
                        elevation: 5,
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          splashColor: Colors.black12,
                          highlightColor: Colors.black12,
                          borderRadius: BorderRadius.circular(25),
                          onTap: () => _deleteOnFirestore(item),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            child: Text(
                              'Sim!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Material(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(45),
                  child: SizedBox(
                    height: 42,
                    width: 42,
                    child: Icon(
                      Icons.priority_high_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void editMessage(BuildContext context, MessageModel item) async {
    input.text = item.message!;

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 75,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: TextField(
                    controller: input,
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: () async {
                      if (input.text.isNotEmpty) {
                        await firebase.firestore
                            .collection('chats')
                            .doc(item.id)
                            .update({
                              'message': input.text,
                              'updated': Timestamp.now().millisecondsSinceEpoch,
                            })
                            .then((_) => Modular.to.pop())
                            .catchError((err) => print(err));
                      }
                    },
                    splashColor: Colors.black12,
                    highlightColor: Colors.black12,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text(
                          'Editar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    input.clear();
  }

  void getMessages() {
    Query query = firebase.firestore.collection('chats');

    query = query.where('key', isEqualTo: widget.friend.key);

    query = query.orderBy('time');

    subscription = query.snapshots().listen((snapshot) {
      var list =
          snapshot.docs.map((e) => MessageModel.fromFirestore(e)).toList();

      list.sort((a, b) => b.time!.compareTo(a.time!));

      if (messages.isEmpty) {
        setState(() {
          messages.addAll(list);
        });
      } else {
        if (list.length == messages.length) {
          for (var i = 0; i < list.length; i++) {
            if (messages[i].message != list[i].message) {
              setState(() {
                messages.removeAt(i);
                messages.insert(i, list[i]);
              });
            }
          }
        } else {
          for (var i in list) {
            if (messages.every((e) => e.id != i.id)) {
              setState(() {
                messages.insert(0, i);
              });
            }
          }
        }
      }
    });
  }

  void sendMessage() async {
    if (input.text.isNotEmpty) {
      await firebase
          .sendMessageToFirestore(
            MessageModel(
              from: store.uid,
              to: widget.friend.uid!,
              message: input.text,
              type: 'text',
              key: widget.friend.key,
              seen: false,
            ),
          )
          .then((value) => input.clear())
          .catchError((err) => print(err));
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    getMessages();
  }

  @override
  void dispose() {
    input.dispose();
    subscription.isPaused ? print('isPaused') : subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        title: Text(widget.friend.name!),
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
                var isMe = store.uid == item.from;

                return buildBubble(
                  context: context,
                  item: item,
                  isMe: isMe,
                  onLongPress: () => deleteMessage(context, item),
                  onDoubleTap: () => editMessage(context, item),
                );
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
}
