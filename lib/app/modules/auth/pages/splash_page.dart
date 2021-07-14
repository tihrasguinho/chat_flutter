import 'package:chat/app/shared/repositories/fb_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1500),
  )..repeat(reverse: true);

  late final anim = Tween<double>(begin: 0.9, end: 1.0)
      .animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

  void checkCurrentUser() async {
    var user = await firebase.auth.authStateChanges().first;

    await Future.delayed(Duration(milliseconds: 1000));

    if (user != null) {
      Modular.to.pushReplacementNamed('/home');
    } else {
      Modular.to.pushReplacementNamed('/signin');
    }
  }

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SizedBox(
          height: size.width * 0.15,
          width: size.width * 0.15,
          child: ScaleTransition(
            scale: anim,
            child: Image.asset('assets/chat.png'),
          ),
        ),
      ),
    );
  }
}
