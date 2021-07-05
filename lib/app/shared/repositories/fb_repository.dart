import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FirebaseRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  _FirebaseRepository();

  Future<void> sendFriendRequest({required String email}) async {
    var prefs = await SharedPreferences.getInstance();

    var map = jsonDecode(prefs.getString('user')!);

    await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) async {
      if (value.docs.isEmpty) throw ChatException('user-not-found');

      await _firestore
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

      await _firestore.collection('requests').add({
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

    await _firestore
        .collection('users')
        .doc(map['uid'])
        .update({'token': ''}).then((value) async {
      await _auth.signOut().then((value) {
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

    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      var doc = await _firestore.collection('users').doc(value.user!.uid).get();

      if (!doc.exists) throw ChatException('user-data-not-found');

      var token = await _messaging.getToken();

      await _firestore.collection('users').doc(value.user!.uid).update({
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
        'friends': doc.data()!['friends'],
        'token': token,
        'since': doc.data()!['since'],
      };

      await prefs.setString('user', jsonEncode(user));
    }).catchError((error) {
      if (error is FirebaseException) {
        throw ChatException(error.code);
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

    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      var token = await _messaging.getToken();

      var user = {
        'name': name,
        'email': email,
        'image': '',
        'friends': <String>[],
        'token': token,
        'since': Timestamp.now().millisecondsSinceEpoch,
        'updated_at': Timestamp.now().millisecondsSinceEpoch,
      };

      await _firestore.collection('users').doc(value.user!.uid).set(user);

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
