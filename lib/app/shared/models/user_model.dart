import 'dart:convert';

class UserModel {
  String uid;
  String name;
  String image;
  String email;
  List<String> friends;
  int since;

  UserModel({
    required this.uid,
    required this.name,
    required this.image,
    required this.email,
    required this.friends,
    required this.since,
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      image: map['image'],
      email: map['email'],
      friends: List<String>.from(map['friends']),
      since: map['since'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
