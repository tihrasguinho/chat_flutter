import 'dart:convert';
import 'dart:io';

import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FirebaseRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  _FirebaseRepository() {
    firestore.settings = Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  Future<void> sendMessageToDatabase(MessageModel message) async {
    var from = 'messages/${message.from}/${message.to}';
    var to = 'messages/${message.to}/${message.from}';

    var push = database.reference().push().key;

    await Future.wait([
      database.reference().child(from).child(push).set(message.toMap()),
      database.reference().child(to).child(push).set(message.toMap()),
    ]).then((_) {}).catchError((error) {
      if (error is FirebaseException) {
        throw ChatException(error.code);
      } else {
        throw Exception(error);
      }
    });
  }

  Future<String> uploadImageToChat(File file) async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    String? url;

    await storage
        .ref()
        .child('chats')
        .child(map['uid'])
        .child('${DateTime.now().toUtc().millisecondsSinceEpoch}-IMAGE.JPEG')
        .putFile(file)
        .then((task) async {
      url = await task.ref.getDownloadURL();
    }).catchError((err) {
      if (err is FirebaseException) {
        throw ChatException(err.code);
      } else {
        throw Exception(err);
      }
    });

    return url!;
  }

  Future<String> changeProfilePicture({required File file}) async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    var url = '';

    await storage
        .ref()
        .child('users')
        .child(map['uid'])
        .child('profile-picture.jpeg')
        .putFile(file)
        .then((task) async {
      url = await task.ref.getDownloadURL();

      await database.reference().child('users').child(map['uid']).update({
        'image': url,
        'updated': DateTime.now().toUtc().millisecondsSinceEpoch,
      }).then((_) {
        print('picture updated!');
      }).catchError((err) {
        if (err is FirebaseException) {
          throw ChatException(err.code);
        } else {
          throw Exception(err);
        }
      });
    }).catchError((err) {
      print(err);
      if (err is FirebaseException) {
        throw ChatException(err.code);
      } else if (err is ChatException) {
        throw err;
      } else {
        throw Exception(err);
      }
    });

    return url;
  }

  Future<void> getCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    await database
        .reference()
        .child('users/${map['uid']}')
        .get()
        .then((snapshot) async {
      var user = UserModel.fromDatabase(snapshot!);

      await prefs.setString('user', user.toJson());
    }).catchError((error) {
      if (error is FirebaseException) {
        throw ChatException(error.code);
      } else if (error is ChatException) {
        throw error;
      } else {
        throw Exception(error);
      }
    });
  }

  Future<void> sendFriendRequest({required String email}) async {
    var prefs = await SharedPreferences.getInstance();

    var user = UserModel.fromJson(prefs.getString('user')!);

    try {
      var users = await database
          .reference()
          .child('users')
          .orderByChild('email')
          .equalTo(email)
          .once();

      if (users.value != null) {
        List<Map> list = <Map>[];

        (users.value as Map).forEach((key, value) {
          list.add({...value, 'uid': key});
        });

        if (user.friends!.contains(list.first['uid'])) {
          throw ChatException('already-friends');
        }

        if (user.uid == list.first['uid']) {
          throw ChatException('cant-add-yourself');
        }

        // check if request exists

        var requests = await database
            .reference()
            .child('requests')
            .child(list.first['uid'])
            .orderByChild('from')
            .equalTo(user.uid)
            .once();

        if (requests.value != null)
          throw ChatException('request-already-exists');

        // writing a new request

        await database
            .reference()
            .child('requests/${list.first['uid']}')
            .push()
            .set({
          'from': user.uid,
          'state': 'awaiting',
          'time': DateTime.now().toUtc().millisecondsSinceEpoch,
        });

        print('request sended!');
      } else {
        throw ChatException('user-not-found');
      }
    } on FirebaseException catch (error) {
      throw ChatException(error.code);
    } on ChatException catch (error) {
      throw error;
    } on Exception catch (error) {
      throw ChatException(error.toString());
    }
  }

  Future<void> signOut() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    await database.reference().child('users/${map['uid']}').update({
      'token': '',
      'updated': DateTime.now().toUtc().millisecondsSinceEpoch,
    }).then((_) async {
      await auth.signOut().then((value) async {
        await prefs.remove('user');
      }).catchError((error) {
        if (error is FirebaseException) {
          throw ChatException(error.code);
        } else {
          throw Exception(error);
        }
      });
    }).catchError((error) {
      if (error is FirebaseException) {
        throw ChatException(error.code);
      } else if (error is ChatException) {
        throw error;
      } else {
        throw Exception(error);
      }
    });
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    var prefs = await SharedPreferences.getInstance();

    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await database
          .reference()
          .child('users/${value.user!.uid}')
          .once()
          .then((snapshot) async {
        var user = UserModel.fromDatabase(snapshot);

        await database.reference().child('users/${value.user!.uid}').update({
          'token': await FirebaseMessaging.instance.getToken(),
          'updated': DateTime.now().toUtc().millisecondsSinceEpoch,
        }).catchError((error) {
          if (error is FirebaseException) {
            throw ChatException(error.code);
          } else {
            throw Exception(error);
          }
        });

        await prefs.setString('user', user.toJson());
      }).catchError((error) {
        if (error is FirebaseException) {
          throw ChatException(error.code);
        } else if (error is ChatException) {
          throw error;
        } else {
          throw Exception(error);
        }
      });
    }).catchError((error) {
      if (error is FirebaseException) {
        throw ChatException(error.code);
      } else if (error is ChatException) {
        throw error;
      } else {
        throw Exception(error);
      }
    });
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty) throw ChatException('name-required');

    var prefs = await SharedPreferences.getInstance();

    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      var token = await FirebaseMessaging.instance.getToken();

      var normalizer = name.replaceAll(' ', '+');

      var url =
          'https://ui-avatars.com/api/?name=$normalizer&size=256&color=000000&background=FFF';

      var user = {
        'name': name,
        'email': email,
        'image': url,
        'token': token,
        'since': DateTime.now().toUtc().millisecondsSinceEpoch,
        'updated': DateTime.now().toUtc().millisecondsSinceEpoch,
      };

      await database
          .reference()
          .child('users/${value.user!.uid}')
          .set(user)
          .then((_) async {
        user['uid'] = value.user!.uid;

        user.remove('updated_at');

        user.remove('token');

        await prefs.setString('user', jsonEncode(user));
      }).catchError((error) {
        if (error is FirebaseException) {
          throw ChatException(error.code);
        } else {
          throw Exception(error);
        }
      });
    }).catchError((error) {
      if (error is FirebaseException) {
        throw ChatException(error.code);
      } else {
        throw Exception(error);
      }
    });
  }
}

class ChatException implements Exception {
  String message;
  ChatException(this.message);
}

final firebase = _FirebaseRepository();
