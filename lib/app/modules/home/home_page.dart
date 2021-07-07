import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/modules/home/widgets/build_message_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomeStore store = Modular.get();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeigth = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Observer(
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              if (store.isDialOpen.value) {
                store.openDial();
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              body: ListView.builder(
                padding: EdgeInsets.only(top: statusBarHeigth + 20),
                itemCount: store.preview.length,
                itemBuilder: (_, i) {
                  var item = store.preview[i];
                  var isMe = item.message.from == store.uid;

                  return buildMessagePreview(isMe, item);
                },
              ),
              floatingActionButton: SpeedDial(
                onPress: () => store.openDial(),
                openCloseDial: store.isDialOpen,
                icon: Icons.add,
                activeIcon: Icons.clear,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                curve: Curves.bounceIn,
                overlayColor: Colors.black,
                overlayOpacity: 0.5,
                renderOverlay: true,
                buttonSize: 64,
                elevation: 5,
                children: [
                  SpeedDialChild(
                    child: Icon(
                      Icons.exit_to_app_rounded,
                      color: Colors.white,
                    ),
                    label: 'Sair',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: () => store.signOut(),
                    backgroundColor: Colors.red,
                  ),
                  SpeedDialChild(
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                    ),
                    label: 'Adicionar amigo',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: () => store.addFriend(context),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SpeedDialChild(
                    child: Icon(
                      Icons.message_rounded,
                      color: Colors.white,
                    ),
                    label: 'Nova conversa',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: () => Modular.to.pushNamed('/home/friends'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SpeedDialChild(
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                    ),
                    label: 'Perfil',
                    labelStyle: TextStyle(fontSize: 16),
                    onTap: () => Modular.to.pushNamed(
                      '/home/profile',
                      arguments: {
                        'isMe': true,
                        'user': store.user,
                      },
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
