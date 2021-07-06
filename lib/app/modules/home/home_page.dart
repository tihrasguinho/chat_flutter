import 'dart:ui';

import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/shared/models/message_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomeStore store = Modular.get();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeigth = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Observer(
                builder: (_) {
                  return ListView.builder(
                    padding: EdgeInsets.only(top: statusBarHeigth + 10),
                    physics: BouncingScrollPhysics(),
                    itemCount: store.preview.length,
                    itemBuilder: (_, i) {
                      var item = store.preview[i];
                      var isMe = item.message.from == store.uid;

                      return buildMessagePreview(isMe, item);
                    },
                  );
                },
              ),
            ),
            buildOverlay(),
            buildFloatingActitionsButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildMessagePreview(bool isMe, MessagePreview item) {
    var date = DateTime.fromMillisecondsSinceEpoch(item.message.time!);
    var time = DateFormat.Hm('pt_BR').format(date);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Material(
        color: Colors.white,
        elevation: 5,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => Modular.to.pushNamed(
            '/home/chat/${item.sender.uid}',
            arguments: {
              'friend': item.sender,
            },
          ),
          splashColor: Colors.black12,
          highlightColor: Colors.black12,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isMe ? 'Você' : item.sender.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        item.message.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOverlay() {
    return Observer(
      builder: (_) {
        return store.show
            ? Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: GestureDetector(
                    onTap: () => {
                      store.setShow(),
                      _controller.reverse(),
                    },
                    child: Container(
                      color: Colors.black26,
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget buildFloatingActitionsButton(BuildContext context) {
    return Positioned.fill(
      child: Observer(
        builder: (_) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildItem(
                title: 'Nova mensagem',
                icon: Icons.add_rounded,
                show: store.show,
                onTap: () => {
                  Modular.to.pushNamed('/home/friends'),
                  store.setShow(),
                  _controller.reverse(),
                },
              ),
              SizedBox(height: 10),
              buildItem(
                title: 'Perfil',
                icon: Icons.person_rounded,
                show: store.show,
                onTap: () => {
                  Modular.to.pushNamed('/home/profile', arguments: {
                    'isMe': true,
                    'user': store.user,
                  }),
                  store.setShow(),
                  _controller.reverse(),
                },
              ),
              SizedBox(height: 10),
              buildItem(
                title: 'Adicionar amigo',
                icon: Icons.person_add_rounded,
                show: store.show,
                onTap: () => {
                  store.setShow(),
                  _controller.reverse(),
                  store.addFriend(context),
                },
              ),
              SizedBox(height: 10),
              buildItem(
                title: 'Configurações',
                icon: Icons.settings_rounded,
                show: store.show,
                onTap: () => {
                  store.setShow(),
                  _controller.reverse(),
                  store.signOut(),
                },
              ),
              SizedBox(height: 10),
              buildItem(
                onTap: () {
                  store.setShow();
                  if (_controller.isDismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
                show: true,
                isMain: true,
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget buildItem({
    String? title,
    IconData? icon,
    Function? onTap,
    bool show = false,
    bool isMain = false,
  }) {
    return show
        ? AnimatedBuilder(
            animation: _controller,
            builder: (_, child) => Opacity(
              opacity: Tween<double>(begin: isMain ? 1.0 : 0.0, end: 1.0)
                  .animate(CurvedAnimation(
                      parent: _controller, curve: Curves.easeIn))
                  .value,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    title != null
                        ? Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: () => {
                        onTap!(),
                      },
                      elevation: 5,
                      child: Icon(icon),
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
