import 'dart:convert';

import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FirebaseRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  _FirebaseRepository();

  Future<dynamic> sendMessageToFirestore(MessageModel message) async {
    var map = message.toMap();

    var data = {
      'from': map['from'],
      'to': map['to'],
      'type': map['type'],
      'message': map['message'],
      'seen': map['seen'],
      'time': Timestamp.now().millisecondsSinceEpoch,
      'updated': Timestamp.now().millisecondsSinceEpoch,
      'key': map['key'],
    };

    await firestore.collection('chats').add(data).then((value) {
      return MessageModel.fromMap({...data, 'id': value.id});
    }).catchError((error) {
      if (error is FirebaseException) {
        throw ChatException(error.code);
      } else if (error is ChatException) {
        throw error;
      } else {
        throw Exception('GENERIC $error');
      }
    });
  }

  Future<List<UserModel>> getFriends() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    var list = <UserModel>[];

    await firestore
        .collection('users')
        .doc(map['uid'])
        .collection('friends')
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var i in value.docs) {
          await firestore.collection('users').doc(i.id).get().then((doc) {
            if (doc.exists) {
              var friend = UserModel.fromFirestore(doc);
              friend.key = i.data()['key'];
              list.add(friend);
            } else {
              throw ChatException('user-not-found');
            }
          }).catchError((err) {
            throw err;
          });
        }
      }
    }).catchError((err) {
      if (err is FirebaseException) {
        throw ChatException(err.code);
      } else if (err is ChatException) {
        throw err;
      } else {
        throw Exception(err);
      }
    });

    return list;
  }

  Future<void> getCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!) as Map<String, dynamic>;

    await firestore
        .collection('users')
        .doc(map['uid'])
        .get()
        .then((snapshot) async {
      if (!snapshot.exists) throw ChatException('user-data-not-founded');

      var user = {
        'uid': snapshot.id,
        'name': snapshot.data()!['name'],
        'email': snapshot.data()!['email'],
        'image': snapshot.data()!['image'],
        'friends': snapshot.data()!['friends'],
        'since': snapshot.data()!['since'],
      };

      print(mapEquals(map, user));

      if (mapEquals(map, user)) {
        throw ChatException('user-data-is-updated');
      } else {
        await prefs.setString('user', jsonEncode(user));
      }
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

    var map = jsonDecode(prefs.getString('user')!);

    await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) throw ChatException('user-not-found');

      await firestore
          .collection('requests')
          .where('from', isEqualTo: map['uid'])
          .get()
          .then((check) {
        if (check.docs.any((e) => e.data()['to'] == value.docs.first.id))
          throw ChatException('request-already-exists');
      }).catchError((error) {
        print(error);

        if (error is FirebaseException) {
          throw ChatException(error.code);
        } else if (error is ChatException) {
          throw error;
        }
      });

      await firestore.collection('requests').add({
        'from': map['uid'],
        'to': value.docs.first.id,
        'state': 'await',
        'time': Timestamp.now().millisecondsSinceEpoch,
      }).catchError((e) {
        print(e);

        if (e is FirebaseException) {
          throw ChatException(e.code);
        } else if (e is ChatException) {
          throw e;
        }
      });
    }).catchError((error) {
      print(error);

      if (error is FirebaseException) {
        throw ChatException(error.code);
      } else if (error is ChatException) {
        throw error;
      }
    });
  }

  Future<void> signOut() async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    await firestore
        .collection('users')
        .doc(map['uid'])
        .update({'token': ''}).then((value) async {
      await auth.signOut().then((value) {
        prefs.remove('user');
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
      var doc = await firestore.collection('users').doc(value.user!.uid).get();

      if (!doc.exists) throw ChatException('user-data-not-found');

      var token = await messaging.getToken();

      await firestore.collection('users').doc(value.user!.uid).update({
        'token': token,
      }).catchError((error) {
        if (error is FirebaseException) {
          throw ChatException(error.code);
        } else {
          throw Exception(error);
        }
      });

      var user = {
        'uid': value.user!.uid,
        'name': doc.data()!['name'],
        'email': doc.data()!['email'],
        'image': doc.data()!['image'],
        'token': token,
        'since': doc.data()!['since'],
      };

      await prefs.setString('user', jsonEncode(user));
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
      var token = await messaging.getToken();

      var user = {
        'name': name,
        'email': email,
        'image': '',
        'token': token,
        'since': Timestamp.now().millisecondsSinceEpoch,
        'updated_at': Timestamp.now().millisecondsSinceEpoch,
      };

      await firestore.collection('users').doc(value.user!.uid).set(user);

      user['uid'] = value.user!.uid;

      user.remove('updated_at');

      await prefs.setString('user', jsonEncode(user));
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
