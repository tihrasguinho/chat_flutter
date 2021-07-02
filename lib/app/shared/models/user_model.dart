import 'dart:convert';

class UserModel {
  String id;
  String firstName;
  String lastName;
  String image;
  String email;
  String accessToken;
  String refreshToken;
  int since;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    required this.since,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'email': email,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'since': since,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      image: map['image'],
      email: map['email'],
      accessToken: map['access_token'],
      refreshToken: map['refresh_token'],
      since: map['since'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
