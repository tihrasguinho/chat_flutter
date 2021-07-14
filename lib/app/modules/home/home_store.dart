import 'dart:async';
import 'dart:convert';

import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/models/message_preview.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase extends Disposable with Store {
  late StreamSubscription<Event> onValue;
  late StreamSubscription<Event> requestsOnValue;

  _HomeStoreBase() {
    _getCurrentUser().whenComplete(() {
      var path = 'messages/${user.uid}';

      onValue = firebase.database
          .reference()
          .child(path)
          .orderByChild('time')
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          (event.snapshot.value as Map)
              .forEach((key, value) async => await updateList(value));
        } else {
          messagesPreview.clear();
        }
      });

      requestsOnValue = firebase.database
          .reference()
          .child('requests/${user.uid}')
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          var keys = <String>[];
          (event.snapshot.value as Map).forEach((key, value) => keys.add(key));

          if (keys.isNotEmpty) updateRequestsCount(keys.length);
        } else {
          updateRequestsCount(0);
        }
      });
    });
  }

  Future<void> updateList(dynamic value) async {
    for (var item in user.friends!) {
      var list = <MessageModel>[];

      (value as Map).forEach((key, value) {
        if (value['from'] == user.uid && value['to'] == item) {
          list.add(
            MessageModel(
              id: key,
              from: value['from'],
              to: value['to'],
              message: value['message'],
              type: value['type'],
              seen: value['seen'],
              time: value['time'],
            ),
          );
        }

        if (value['from'] == item && value['to'] == user.uid) {
          list.add(
            MessageModel(
              id: key,
              from: value['from'],
              to: value['to'],
              message: value['message'],
              type: value['type'],
              seen: value['seen'],
              time: value['time'],
            ),
          );
        }
      });

      list.sort((a, b) => a.time.compareTo(b.time));

      if (list.isNotEmpty) {
        var count =
            list.where((e) => !e.seen && e.from != user.uid).toList().length;

        var doc = await firebase.database
            .reference()
            .child('users')
            .child(item)
            .once();

        if (doc.value != null) {
          var preview = MessagePreview(
            sender: UserModel.fromDatabase(doc),
            message: list.last,
            unread: count,
          );

          if (messagesPreview.any((e) => e.sender.uid == preview.sender.uid)) {
            messagesPreview
                .removeWhere((e) => e.sender.uid == preview.sender.uid);
            messagesPreview.insert(0, preview);
          } else {
            messagesPreview.insert(0, preview);
          }

          messagesPreview
              .sort((a, b) => b.message.time.compareTo(a.message.time));
        }
      }
    }
  }

  @observable
  UserModel user = UserModel();

  @observable
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @observable
  int requestsCount = 0;

  @observable
  List<MessagePreview> messagesPreview = ObservableList<MessagePreview>();

  @action
  void openDial() => isDialOpen.value = !isDialOpen.value;

  @action
  updateRequestsCount(int val) => requestsCount = val;

  @action
  updateUser({
    String? name,
    String? email,
    String? image,
  }) {
    if (name != null) user.name = name;
    if (email != null) user.email = email;
    if (image != null) user.image = image;

    user = UserModel.fromMap(user.toMap());
  }

  @action
  signOut() async {
    try {
      await firebase.signOut();
      return Modular.to.pushReplacementNamed('/');
    } on ChatException catch (e) {
      print(e.message);
    } on Exception catch (e) {
      print(e);
    }
  }

  @action
  addFriend(BuildContext context) async {
    var _controller = TextEditingController();

    var message = await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              'Adicionar novo amigo!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Material(
              color: Theme.of(context).primaryColor,
              elevation: 5,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () async => firebase
                    .sendFriendRequest(email: _controller.text)
                    .then((_) {
                  Modular.to.pop();
                }).catchError((err) {
                  print(err.message);
                }),
                // onTap: () async => await firebase
                //     .sendFriendRequest(email: _controller.text)
                //     .then((value) {
                //   Modular.to.pop('Solicitação enviada com sucesso!');
                // }).catchError((err) {
                //   if (err is ChatException) {
                //     print(err.message);

                //     switch (err.message) {
                //       case 'request-already-exists':
                //         {
                //           Modular.to.pop('Solicitação já enviada!');
                //           break;
                //         }
                //       case 'user-not-found':
                //         {
                //           Modular.to.pop('Usuário não encontrado!');
                //           break;
                //         }
                //       default:
                //         {
                //           Modular.to
                //               .pop('Erro incomum, tente novamente mais tarde!');
                //           break;
                //         }
                //     }
                //   } else {
                //     Modular.to.pop('Erro incomum, tente novamente mais tarde!');
                //   }
                // }),
                splashColor: Colors.black12,
                highlightColor: Colors.black12,
                borderRadius: BorderRadius.circular(25),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );

    if (message is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(milliseconds: 2500),
        ),
      );
    }
  }

  Future<void> _getCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    user = UserModel.fromMap(map);
  }

  @override
  void dispose() {
    onValue.cancel();
    requestsOnValue.cancel();
  }
}
