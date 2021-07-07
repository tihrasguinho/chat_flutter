import 'package:chat/app/modules/home/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final HomeStore store = Modular.get();

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
        builder: (_) {
          return store.friends.isEmpty
              ? Center(
                  child: Text('nenhum amigo adicionado'),
                )
              : ListView.builder(
                  itemCount: store.friends.length,
                  itemBuilder: (_, i) {
                    var item = store.friends[i];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Material(
                        color: Colors.white,
                        elevation: 5,
                        borderRadius: BorderRadius.circular(4),
                        child: InkWell(
                          onTap: () => {
                            Modular.to.popAndPushNamed(
                              '/home/chat/${item.uid}',
                              arguments: {
                                'friend': item,
                              },
                            )
                          },
                          borderRadius: BorderRadius.circular(4),
                          splashColor: Colors.black12,
                          highlightColor: Colors.black12,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      item.email!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
