import 'dart:async';
import 'dart:convert';

import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/models/message_preview.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase extends Disposable with Store {
  _HomeStoreBase() {
    getCurrentUser();
    loadLastMessages();
  }

  late StreamSubscription<QuerySnapshot> subscription;

  @observable
  UserModel user = UserModel(
    uid: '',
    name: '',
    image: '',
    email: '',
    since: 0,
  );

  @computed
  String get uid => user.uid;

  @observable
  List<MessagePreview> preview = ObservableList<MessagePreview>();

  @observable
  bool _show = false;

  @computed
  bool get show => _show;

  @action
  setShow() => _show = !_show;

  @action
  loadLastMessages() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    await firebase.getFriends().then((value) {
      value.forEach((e) async {
        var keyOne = base64UrlEncode(utf8.encode('${map['uid']}:${e.uid}'));

        var keyTwo = base64UrlEncode(utf8.encode('${e.uid}:${map['uid']}'));

        Query query = firebase.firestore.collection('chats');

        query = query.where('key', whereIn: [keyOne, keyTwo]).orderBy('time');

        subscription = query.snapshots().listen((snap) {
          if (snap.size > 0) {
            var data = snap.docs.last.data() as Map;

            if (preview.any(
                (e) => e.message.key == keyOne || e.message.key == keyTwo)) {
              preview.removeWhere(
                  (e) => e.message.key == keyOne || e.message.key == keyTwo);

              preview.insert(
                0,
                MessagePreview(
                  sender: e,
                  message: MessageModel(
                    from: data['from'],
                    to: data['to'],
                    message: data['message'],
                    type: data['type'],
                    key: data['key'],
                    time: data['time'],
                    updated: data['updated'],
                    id: snap.docs.first.id,
                  ),
                ),
              );
            } else {
              preview.insert(
                0,
                MessagePreview(
                  sender: e,
                  message: MessageModel(
                    from: data['from'],
                    to: data['to'],
                    message: data['message'],
                    type: data['type'],
                    key: data['key'],
                    time: data['time'],
                    updated: data['updated'],
                    id: snap.docs.first.id,
                  ),
                ),
              );
            }
          }
        });
      });
    }).catchError((err) {
      print(err);
    });
  }

  @action
  Future getCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    user = UserModel.fromMap(map);
  }

  @action
  signOut() async {
    try {
      await firebase.signOut();

      return Modular.to.pushReplacementNamed('/');
    } on ChatException catch (e) {
      print(e);
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
                onTap: () async => await firebase
                    .sendFriendRequest(email: _controller.text)
                    .then((value) {
                  Modular.to.pop('Solicitação enviada com sucesso!');
                }).catchError((err) {
                  if (err is ChatException) {
                    print(err.message);

                    switch (err.message) {
                      case 'request-already-exists':
                        {
                          Modular.to.pop('Solicitação já enviada!');
                          break;
                        }
                      case 'user-not-found':
                        {
                          Modular.to.pop('Usuário não encontrado!');
                          break;
                        }
                      default:
                        {
                          Modular.to
                              .pop('Erro incomum, tente novamente mais tarde!');
                          break;
                        }
                    }
                  } else {
                    Modular.to.pop('Erro incomum, tente novamente mais tarde!');
                  }
                }),
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

  @override
  void dispose() {
    subscription.cancel();
  }
}
