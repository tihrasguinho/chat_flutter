import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'signup_store.g.dart';

class SignupStore = _SignupStoreBase with _$SignupStore;

abstract class _SignupStoreBase with Store {
  @observable
  bool _isLoading = false;

  @computed
  bool get loading => _isLoading;

  @action
  setLoading() => _isLoading = !_isLoading;

  @action
  Future createUser(
      BuildContext context, String name, String email, String password) async {
    if (name.isEmpty) return;

    try {
      FocusScope.of(context).unfocus();

      setLoading();

      await firebase.createUser(
        name: name,
        email: email,
        password: password,
      );

      return Modular.to.pop(true);
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
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        duration: Duration(seconds: 3),
      ),
    );
  }
}
