import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'signin_store.g.dart';

class SigninStore = _SigninStoreBase with _$SigninStore;

abstract class _SigninStoreBase with Store {
  @observable
  bool _otherConnections = true;

  @observable
  bool _isLoading = false;

  @computed
  bool get loading => _isLoading;

  @computed
  bool get other => _otherConnections;

  @action
  setLoading() => _isLoading = !_isLoading;

  @action
  setOtherConnections() => _otherConnections = !_otherConnections;

  @action
  Future signIn(BuildContext context, String email, String password) async {
    try {
      FocusScope.of(context).unfocus();

      setLoading();

      await firebase.loginUser(email: email, password: password);

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
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
