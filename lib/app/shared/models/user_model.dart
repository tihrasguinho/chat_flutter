import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? uid;
  String? name;
  String? image;
  String? email;
  List<String>? friends;
  int? since;

  UserModel({
    this.uid,
    this.name,
    this.image,
    this.email,
    this.friends,
    this.since,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'image': image,
      'email': email,
      'friends': friends,
      'since': since,
    };
  }

  factory UserModel.fromDatabase(DataSnapshot data) {
    var list = <String>[];

    if (data.value['friends'] != null) {
      (data.value['friends'] as Map).forEach((key, value) => list.add(key));
    }

    return UserModel(
      uid: data.key,
      name: data.value['name'],
      email: data.value['email'],
      image: data.value['image'],
      friends: list,
      since: data.value['since'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      image: map['image'],
      email: map['email'],
      friends: map['friends'] != null ? List<String>.from(map['friends']) : [],
      since: map['since'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
