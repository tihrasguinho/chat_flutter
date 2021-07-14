import 'dart:ui';

import 'package:chat/app/modules/auth/stores/signin_store.dart';
import 'package:chat/app/modules/home/widgets/build_texttield.dart';
import 'package:chat/app/modules/home/widgets/buttom_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends ModularState<SigninPage, SigninStore>
    with TickerProviderStateMixin {
  late final ctrl = AnimationController(
    vsync: this,
    duration: Duration(seconds: 5),
  )..repeat(reverse: true);

  late final scale = Tween<double>(begin: 0.9, end: 1.0)
      .animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));

  late final anim = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 0.05))
      .animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));

  late final email = TextEditingController();

  late final password = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.7, 1.0],
            colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorLight,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: Observer(builder: (_) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.5,
                      height: size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(35),
                        child: SlideTransition(
                          position: anim,
                          child: ScaleTransition(
                            scale: scale,
                            child: Image.asset(
                              'assets/conversation.png',
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Flutter',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                            text: '\nChat Application',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    controller.other ? otherConnections() : emailAndPassword(),
                  ],
                ),
                controller.loading
                    ? Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.white10,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            );
          }),
          bottomNavigationBar: Observer(
            builder: (_) => controller.loading
                ? SizedBox()
                : TextButton(
                    onPressed: () async {
                      var res = await Modular.to.pushNamed('/signup');

                      if (res is bool) {
                        if (res) Modular.to.pushReplacementNamed('/home');
                      }
                    },
                    child: Text(
                      'Criar uma nova conta!',
                      style: TextStyle(
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget emailAndPassword() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      builder: (_, value, child) => Opacity(
        opacity: value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildTextField(
              hint: 'email',
              icon: Icons.alternate_email_rounded,
              inputType: TextInputType.emailAddress,
              ctrl: email,
            ),
            SizedBox(height: 10),
            buildTextField(
              hint: 'senha',
              icon: Icons.lock_rounded,
              inputType: TextInputType.text,
              ctrl: password,
              obscure: true,
            ),
            SizedBox(height: 10),
            ButtonCustom(
              context: context,
              backgroundColor: Theme.of(context).primaryColorDark,
              title: 'Entrar',
              onTap: () => controller.signIn(
                context,
                email.text,
                password.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget otherConnections() {
    return Column(
      children: [
        materialBtn(
          bgColor: Colors.white,
          assetName: 'google.png',
          title: 'Entrar com uma conta Google!',
          onPressed: () {},
        ),
        SizedBox(height: 10),
        materialBtn(
          bgColor: Color(0xFF4267B2),
          color: Colors.white,
          textColor: Colors.white,
          assetName: 'facebook.png',
          title: 'Entrar com uma conta Facebook!',
          onPressed: () {},
        ),
        SizedBox(height: 10),
        materialBtn(
          bgColor: Theme.of(context).primaryColorDark,
          textColor: Colors.white,
          title: 'Entrar com email e senha!',
          isCentered: true,
          onPressed: () => controller.setOtherConnections(),
        ),
      ],
    );
  }
}

Widget materialBtn({
  required Color bgColor,
  required String title,
  String? assetName,
  Color? color,
  Color? textColor,
  bool? isCentered = false,
  Function? onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 30,
    ),
    child: Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(4),
      elevation: 2,
      child: InkWell(
        onTap: () => onPressed!(),
        splashColor: Colors.black12,
        highlightColor: Colors.black12,
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: isCentered!
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              SizedBox(width: assetName != null ? 20 : 0),
              assetName != null
                  ? Image.asset(
                      'assets/$assetName',
                      height: 24,
                    )
                  : SizedBox(),
              SizedBox(width: assetName != null ? 10 : 0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
