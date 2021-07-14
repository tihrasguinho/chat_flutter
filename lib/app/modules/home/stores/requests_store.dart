import 'dart:async';

import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'requests_store.g.dart';

class RequestsStore = _RequestsStoreBase with _$RequestsStore;

abstract class _RequestsStoreBase extends Disposable with Store {
  final HomeStore home = Modular.get();

  late StreamSubscription<Event> stream;

  _RequestsStoreBase() {
    stream = firebase.database
        .reference()
        .child('requests/${home.user.uid}')
        .onValue
        .listen((event) async {
      if (event.snapshot.value != null) {
        (event.snapshot.value as Map).forEach((key, value) async {
          var doc = await firebase.database
              .reference()
              .child('users')
              .child(value['from'])
              .once();

          if (doc.value != null) {
            requests.add(UserModel.fromDatabase(doc));
          }
        });
      }
    });
  }

  @observable
  List<UserModel> requests = ObservableList<UserModel>();

  void dispose() {
    stream.cancel();
  }
}
