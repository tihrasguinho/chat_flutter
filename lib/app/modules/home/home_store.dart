import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  @observable
  bool _show = false;

  @computed
  bool get show => _show;

  @action
  setShow() => _show = !_show;

  @action
  signOut() async {
    try {
      await firebase.signOut();

      return Modular.to.pushReplacementNamed('/');
    } on ChatException catch (e) {
      print(e);
    } on Exception catch (e) {
      print(e);
    }
  }

  @action
  addFriend(BuildContext context) async {
    var _controller = TextEditingController();

    var message = await showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Text(
              'Adicionar novo amigo!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  alignLabelWithHint: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Material(
              color: Theme.of(context).primaryColor,
              elevation: 5,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () async => await firebase
                    .sendFriendRequest(email: _controller.text)
                    .then((value) {
                  Modular.to.pop('Solicitação enviada com sucesso!');
                }).catchError((err) {
                  if (err is ChatException) {
                    print(err.message);

                    switch (err.message) {
                      case 'request-already-exists':
                        {
                          Modular.to.pop('Solicitação já enviada!');
                          break;
                        }
                      case 'user-not-found':
                        {
                          Modular.to.pop('Usuário não encontrado!');
                          break;
                        }
                      default:
                        {
                          Modular.to
                              .pop('Erro incomum, tente novamente mais tarde!');
                          break;
                        }
                    }
                  } else {
                    Modular.to.pop('Erro incomum, tente novamente mais tarde!');
                  }
                }),
                splashColor: Colors.black12,
                highlightColor: Colors.black12,
                borderRadius: BorderRadius.circular(25),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );

    if (message is String) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(milliseconds: 2500),
        ),
      );
    }
  }
}
