import 'package:chat/app/modules/home/pages/chat_page.dart';
import 'package:chat/app/modules/home/pages/friends_page.dart';
import 'package:chat/app/modules/home/pages/profile_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../home/home_store.dart';

import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => HomePage()),
    ChildRoute(
      '/chat',
      child: (_, args) => ChatPage(
        friend: args.data['friend'],
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
  ];
}
