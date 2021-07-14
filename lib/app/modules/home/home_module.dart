import 'package:chat/app/modules/home/pages/chat_page.dart';
import 'package:chat/app/modules/home/pages/crop_page.dart';
import 'package:chat/app/modules/home/pages/friends_page.dart';
import 'package:chat/app/modules/home/pages/profile_page.dart';
import 'package:chat/app/modules/home/pages/requests_page.dart';
import 'package:chat/app/modules/home/stores/chat_store.dart';
import 'package:chat/app/modules/home/stores/friends_store.dart';
import 'package:chat/app/modules/home/stores/profile_store.dart';
import 'package:chat/app/modules/home/stores/requests_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../home/home_store.dart';

import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
    Bind.factory((i) => ChatStore()),
    Bind.lazySingleton((i) => FriendsStore()),
    Bind.factory((i) => ProfileStore()),
    Bind.factory((i) => RequestsStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => HomePage()),
    ChildRoute(
      '/chat/:id',
      child: (_, args) => ChatPage(
        friend: args.data['friend'],
        uid: args.params['id'],
      ),
      transition: TransitionType.rightToLeftWithFade,
    ),
    ChildRoute(
      '/friends',
      child: (_, args) => FriendsPage(),
      transition: TransitionType.fadeIn,
    ),
    ChildRoute(
      '/profile',
      child: (_, args) => ProfilePage(
        isMe: args.data['isMe'],
        user: args.data['user'],
      ),
      transition: TransitionType.rightToLeftWithFade,
    ),
    ChildRoute(
      '/crop',
      child: (_, args) => CropPage(
        file: args.data['file'],
      ),
      transition: TransitionType.fadeIn,
    ),
    ChildRoute(
      '/requests',
      child: (_, args) => RequestsPage(),
      transition: TransitionType.fadeIn,
    ),
  ];
}
