import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void popUpToAddNewFriend({
  required BuildContext context,
  Function? onPress,
}) async {
  final _controller = TextEditingController();

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
              onTap: () async {
                try {
                  await firebase.sendFriendRequest(email: _controller.text);

                  Modular.to.pop('Solicitação enviada com sucesso!');
                } on ChatException catch (error) {
                  switch (error.message) {
                    case 'cant-add-yourself':
                      {
                        Modular.to.pop('Você não pode adicionar a si mesmo!');
                        break;
                      }
                    case 'already-friends':
                      {
                        Modular.to.pop('Usuário já é seu amigo!');
                        break;
                      }
                    case 'request-already-exists':
                      {
                        Modular.to.pop('Já existe uma solicitação aguardando!');
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
                }
              },
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
