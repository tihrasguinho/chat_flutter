import 'dart:convert';

import 'package:chat/app/shared/models/user_model.dart';
import 'package:chat/app/shared/repositories/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final repository = ApiRepository();

  @observable
  bool _loading = true;

  @observable
  var firstName = TextEditingController();

  @observable
  var lastName = TextEditingController();

  @observable
  var email = TextEditingController();

  @observable
  var password = TextEditingController();

  @computed
  bool get loading => _loading;

  @action
  setLoading() => _loading = !_loading;

  @action
  Future checkLoggedUser() async {
    var prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('user')) {
      Modular.to.pushReplacementNamed('/home');
    } else {
      setLoading();
    }
  }

  @action
  void clearInputs() {
    firstName.clear();
    lastName.clear();
    email.clear();
    password.clear();
  }

  @action
  Future<dynamic> signIn(BuildContext context) async {
    FocusScope.of(context).unfocus();

    var prefs = await SharedPreferences.getInstance();

    var data = await repository.signIn(
      email: email.text,
      password: password.text,
    );

    if (data['statusCode'] == 200) {
      var mUser = UserModel(
        id: data['user']['id'],
        firstName: data['user']['first_name'],
        lastName: data['user']['last_name'],
        image: data['user']['image'],
        email: data['user']['email'],
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        since: data['user']['since'],
      );

      await prefs.setString('user', json.encode(mUser.toMap()));

      return Modular.to.pushReplacementNamed('/home');
    } else {
      print(data['message']);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (data['message'] as String).toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 2500),
        ),
      );
    }
  }

  @action
  Future<dynamic> createUser(BuildContext context) async {
    FocusScope.of(context).unfocus();

    var prefs = await SharedPreferences.getInstance();

    var data = await repository.signUp(
      firstName: firstName.text,
      lastName: lastName.text,
      email: email.text,
      password: password.text,
    );

    if (data['statusCode'] == 200) {
      var mUser = UserModel(
        id: data['user']['id'],
        firstName: data['user']['first_name'],
        lastName: data['user']['last_name'],
        image: data['user']['image'],
        email: data['user']['email'],
        accessToken: data['access_token'],
        refreshToken: data['refresh_token'],
        since: data['user']['since'],
      );

      await prefs.setString('user', json.encode(mUser.toMap()));

      return Modular.to.pushReplacementNamed('/home');
    } else {
      print(data['message']);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (data['message'] as String).toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 2500),
        ),
      );
    }
  }
}
