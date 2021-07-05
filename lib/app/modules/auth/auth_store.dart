import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  @observable
  bool _loading = true;

  @observable
  var name = TextEditingController();

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
    name.clear();
    email.clear();
    password.clear();
  }

  @action
  Future signIn(BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();

      setLoading();

      await firebase.loginUser(email: email.text, password: password.text);

      return Modular.to.pushReplacementNamed('/home');
    } on ChatException catch (e) {
      setLoading();

      print(e.message);

      switch (e.message) {
        case 'wrong-password':
          return showError('Senha incorreta!', context);
        case 'invalid-email':
          return showError('Email inválido!', context);
        case 'user-not-found':
          return showError('Usuário não encontrado!', context);
        case 'unknown':
          return showError('Dados obrigatórios!', context);
        default:
          return showError(
              'Erro incomum, tente novamente mais tarde!', context);
      }
    } on Exception catch (e) {
      setLoading();

      print(e);

      return showError('Erro incomum, tente novamente mais tarde!', context);
    }
  }

  @action
  Future createUser(BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();

      setLoading();

      await firebase.createUser(
        name: name.text,
        email: email.text,
        password: password.text,
      );

      return Modular.to.pushReplacementNamed('/home');
    } on ChatException catch (e) {
      setLoading();

      switch (e.message) {
        case 'invalid-email':
          return showError('Email inválido!', context);
        case 'weak-password':
          return showError('Sua senha precisa ser mais forte!', context);
        case 'email-already-in-use':
          return showError('Este email já está em uso!', context);
        case 'unknown':
          return showError('Problema com dados enviados!', context);
        case 'name-required':
          return showError('Seu nome stá em branco!', context);
        default:
          return showError(
              'Erro incomum, tente novamente mais tarde!', context);
      }
    } on Exception catch (e) {
      setLoading();
      print(e);
      return showError('Erro incomum, tente novamente mais tarde!', context);
    }
  }

  void showError(String message, context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
