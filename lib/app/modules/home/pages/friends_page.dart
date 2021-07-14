import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/modules/home/stores/friends_store.dart';
import 'package:chat/app/modules/home/widgets/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends ModularState<FriendsPage, FriendsStore> {
  final HomeStore home = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        title: Text('Amigos'),
      ),
      body: Observer(
        builder: (_) => controller.isEmpty
            ? Center(
                child: Text(
                  'Nenhum amigo adicionado ainda!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.only(top: 5),
                itemCount: controller.friends.length,
                itemBuilder: (_, i) {
                  var item = controller.friends[i];

                  return UserView(
                    item: item,
                    onPressed: () => Modular.to.popAndPushNamed(
                      '/home/chat/${item.uid}',
                      arguments: {
                        'friend': item,
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
