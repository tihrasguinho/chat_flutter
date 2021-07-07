import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? name;
  String? image;
  String? email;
  String? key;
  int? since;

  UserModel({
    this.uid,
    this.name,
    this.image,
    this.email,
    this.key,
    this.since,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'image': image,
      'email': email,
      'since': since,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'],
      image: data['image'],
      email: data['email'],
      since: data['since'],
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      image: map['image'],
      email: map['email'],
      since: map['since'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
