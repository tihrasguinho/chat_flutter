import 'dart:async';
import 'dart:io';

import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase extends Disposable with Store {
  final HomeStore home = Modular.get();

  late StreamSubscription<Event> subscription;

  _ProfileStoreBase() {
    var isMe = Modular.args!.data['isMe'] as bool;

    if (!isMe) {
      var friend = Modular.args!.data['user'] as UserModel;

      subscription = firebase.database
          .reference()
          .child('requests')
          .child(home.user.uid!)
          .orderByChild('from')
          .equalTo(friend.uid)
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          _showAcceptButton = true;
        } else {
          _showAcceptButton = false;
        }
      });
    }
  }

  @observable
  bool _showAcceptButton = false;

  @computed
  bool get showBtn => _showAcceptButton;

  @observable
  bool _loading = false;

  @computed
  bool get loading => _loading;

  @action
  setLoading(bool val) => _loading = val;

  @action
  Future<void> acceptFriendship() async {
    var friend = Modular.args!.data['user'] as UserModel;

    var snapshot = await firebase.database
        .reference()
        .child('requests')
        .child(home.user.uid!)
        .orderByChild('from')
        .equalTo(friend.uid)
        .once();

    if (snapshot.value != null) {
      (snapshot.value as Map).forEach((key, value) async {
        await firebase.database
            .reference()
            .child('requests')
            .child(home.user.uid!)
            .child(key)
            .update({'state': 'accepted'}).catchError((err) {
          print(err);
        });
      });
    }
  }

  @action
  Future<void> changeImage() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setLoading(true);

    var cropped = await Modular.to.pushNamed(
      '/home/crop',
      arguments: {'file': File(pickedFile.path)},
    );

    if (cropped is File) {
      try {
        var url = await firebase.changeProfilePicture(file: cropped);

        home.updateUser(image: url);

        await (await SharedPreferences.getInstance())
            .setString('user', home.user.toJson());

        setLoading(false);
      } on ChatException catch (e) {
        setLoading(false);

        print(e.message);
      } on Exception catch (e) {
        setLoading(false);

        print(e.toString());
      }
    } else {
      return;
    }
  }

  void dispose() {
    var isMe = Modular.args!.data['isMe'] as bool;

    if (!isMe && !subscription.isPaused) {
      subscription.cancel();
    }
  }
}
