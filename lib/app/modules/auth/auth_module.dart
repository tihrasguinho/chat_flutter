import 'package:chat/app/modules/auth/pages/signin_page.dart';
import 'package:chat/app/modules/auth/pages/signup_page.dart';
import 'package:chat/app/modules/auth/pages/splash_page.dart';
import 'package:chat/app/modules/auth/stores/signin_store.dart';
import 'package:chat/app/modules/auth/stores/signup_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.factory((i) => SigninStore()),
    Bind.factory((i) => SignupStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SplashPage()),
    ChildRoute('/signin', child: (_, args) => SigninPage()),
    ChildRoute('/signup', child: (_, args) => SignupPage()),
  ];
}
