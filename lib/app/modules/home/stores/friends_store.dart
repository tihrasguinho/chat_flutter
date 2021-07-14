import 'dart:async';

import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'friends_store.g.dart';

class FriendsStore = _FriendsStoreBase with _$FriendsStore;

abstract class _FriendsStoreBase extends Disposable with Store {
  final HomeStore home = Modular.get();
  late StreamSubscription<Event> stream;

  _FriendsStoreBase() {
    stream = firebase.database
        .reference()
        .child('users/${home.user.uid}/friends')
        .onValue
        .listen((event) async {
      if (event.snapshot.value != null) {
        var uids = <dynamic>[];

        (event.snapshot.value as Map).forEach((key, value) => uids.add(key));

        for (var item in uids) {
          var data =
              await firebase.database.reference().child('users/$item').once();

          if (data.value != null) {
            var user = UserModel.fromDatabase(data);

            insertIntoFriends(user);
          }
        }
      } else {
        setEmpty(true);
      }
    });
  }

  @observable
  bool isEmpty = false;

  @observable
  List<UserModel> friends = ObservableList<UserModel>();

  @action
  setEmpty(bool val) => isEmpty = val;

  @action
  void insertIntoFriends(UserModel user) {
    if (friends.every((e) => e.uid != user.uid)) {
      friends.add(user);
    }
  }

  void dispose() {
    stream.isPaused ? print('Stream is paused!') : stream.cancel();
  }
}
