import 'dart:async';
import 'dart:io';

import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'chat_store.g.dart';

class ChatStore = _ChatSoreBase with _$ChatStore;

abstract class _ChatSoreBase extends Disposable with Store {
  final HomeStore home = Modular.get();

  late StreamSubscription<Event> onAdded;
  late StreamSubscription<Event> onChanged;
  late StreamSubscription<Event> onRemoved;

  late String? friend;

  _ChatSoreBase() {
    friend = Modular.args!.params['id'];

    print(friend);

    _getInitialMessages().whenComplete(() => markAsSeen());

    input.addListener(() {
      empty = input.value.text.isEmpty;
    });

    var path = 'messages/${home.user.uid}/$friend';

    onAdded = firebase.database
        .reference()
        .child(path)
        .orderByChild('time')
        .onChildAdded
        .listen((event) {
      insertMessage(MessageModel.fromDatabase(event.snapshot));

      markAsSeen();
    });

    onChanged = firebase.database
        .reference()
        .child(path)
        .orderByChild('time')
        .onChildChanged
        .listen((event) {
      updatedMessage(MessageModel.fromDatabase(event.snapshot));
    });

    onRemoved = firebase.database
        .reference()
        .child(path)
        .orderByChild('time')
        .onChildRemoved
        .listen((event) {
      removeMessage(MessageModel.fromDatabase(event.snapshot));
    });
  }

  @observable
  var input = TextEditingController();

  @observable
  MessageModel? reply;

  @observable
  bool empty = true;

  @observable
  bool loading = false;

  @observable
  List<MessageModel> messages = ObservableList<MessageModel>();

  @action
  setLoading(bool val) => loading = val;

  Future<void> _getInitialMessages() async {
    var path = 'messages/${home.user.uid}/$friend';

    var snapshot = await firebase.database.reference().child(path).once();

    if (snapshot.value != null) {
      (snapshot.value as Map).forEach(
        (key, value) => messages.add(
          MessageModel(
            id: key,
            from: value['from'],
            to: value['to'],
            message: value['message'],
            type: value['type'],
            seen: value['seen'],
            time: value['time'],
          ),
        ),
      );

      messages.sort((a, b) => b.time.compareTo(a.time));
    }
  }

  // edit a message

  Future<void> editMessage(MessageModel message) async {
    if (message.from == home.user.uid) {
      if (input.text.isNotEmpty) {
        var path = 'messages/${home.user.uid}/$friend/${message.id}';

        var reverse = 'messages/$friend/${home.user.uid}/${message.id}';

        var time = DateTime.now().toUtc().millisecondsSinceEpoch;

        await Future.wait<void>([
          firebase.database
              .reference()
              .child(path)
              .update({'message': input.text, 'updated': time}),
          firebase.database
              .reference()
              .child(reverse)
              .update({'message': input.text, 'updated': time}),
        ])
            .then((value) => {
                  Modular.to.pop(),
                  input.clear(),
                })
            .catchError((err) {
          print(err);
        });
      }
    }
  }

  // send text message

  @action
  Future<void> sendMessage(String uid) async {
    try {
      await firebase.sendMessageToDatabase(
        MessageModel(
          from: home.user.uid!,
          to: uid,
          message: input.text,
          type: 'text',
          seen: false,
          time: DateTime.now().toUtc().millisecondsSinceEpoch,
          updated: DateTime.now().toUtc().millisecondsSinceEpoch,
        ),
      );

      input.clear();
    } on ChatException catch (err) {
      print(err.message);
    } on Exception catch (err) {
      print(err.toString());
    }
  }

  // send image message

  @action
  Future<void> sendImageToChat(String uid) async {
    setLoading(true);

    var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      setLoading(false);

      return;
    }

    var cropped = await Modular.to.pushNamed(
      '/home/crop',
      arguments: {
        'needAspectRatio': false,
        'file': File(pickedFile.path),
      },
    );

    if (cropped is File) {
      try {
        var url = await firebase.uploadImageToChat(cropped);

        await firebase.sendMessageToDatabase(
          MessageModel(
            from: home.user.uid!,
            to: uid,
            message: url,
            type: 'image',
            seen: false,
            time: DateTime.now().toUtc().millisecondsSinceEpoch,
          ),
        );

        setLoading(false);
      } on ChatException catch (error) {
        print(error.message);
      }
    } else {
      setLoading(false);
    }
  }

  // delete message

  @action
  Future<void> deleteMessage(MessageModel message) async {
    if (message.from == home.user.uid) {
      if (message.type == 'image') {
        var ref = firebase.storage.refFromURL(message.message);

        print(ref.fullPath);

        await firebase.storage.ref(ref.fullPath).delete();
      }

      var path = 'messages/${home.user.uid}/$friend/${message.id}';
      var reverse = 'messages/$friend/${home.user.uid}/${message.id}';

      await Future.wait<void>([
        firebase.database.reference().child(path).remove(),
        firebase.database.reference().child(reverse).remove(),
      ]).then((value) => Modular.to.pop()).catchError((err) {
        print(err);
      });
    }
  }

  // update messages when its seen

  @action
  Future<void> markAsSeen() async {
    for (var i = 0; i < messages.length; i++) {
      var item = messages[i];

      if (!item.seen && item.from != home.user.uid) {
        var pathToMe = 'messages/${home.user.uid}/$friend/${item.id}';

        var pathToFriend = 'messages/$friend/${home.user.uid}/${item.id}';

        var time = DateTime.now().toUtc().millisecondsSinceEpoch;

        await Future.wait([
          firebase.database.reference().child(pathToMe).update({
            'seen': true,
            'updated': time,
          }),
          firebase.database.reference().child(pathToFriend).update({
            'seen': true,
            'updated': time,
          }),
        ]).then((_) {}).catchError((err) {
          print(err);
        });
      }
    }
  }

  @action
  void removeMessage(MessageModel message) {
    if (messages.any((e) => e.id == message.id)) {
      messages.removeWhere((e) => e.id == message.id);
    }
  }

  @action
  void updatedMessage(MessageModel message) {
    if (messages.any((e) => e.id == message.id)) {
      messages.removeWhere((e) => e.id == message.id);
      messages.add(message);
      messages.sort((a, b) => b.time.compareTo(a.time));
    }
  }

  @action
  void insertMessage(MessageModel message) {
    if (messages.every((e) => e.id != message.id)) {
      messages.insert(0, message);
    }
  }

  void dispose() {
    onAdded.cancel();
    onChanged.cancel();
    onRemoved.cancel();
    input.dispose();
  }
}
