import 'dart:ui';

import 'package:chat/app/modules/auth/stores/signup_store.dart';
import 'package:chat/app/modules/home/widgets/build_texttield.dart';
import 'package:chat/app/modules/home/widgets/buttom_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ModularState<SignupPage, SignupStore> {
  late final name = TextEditingController();
  late final email = TextEditingController();
  late final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusBarheigth = MediaQuery.of(context).padding.top;
    return Container(
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
        body: Observer(
          builder: (_) {
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: statusBarheigth),
                    SizedBox(
                      height: 52,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Modular.to.pop(),
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    SizedBox(
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      child: Image.asset('assets/registration.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Cadastro de novo usuário',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
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
                    SizedBox(height: 20),
                    buildTextField(
                      hint: 'nome',
                      icon: Icons.person_rounded,
                      inputType: TextInputType.text,
                      ctrl: name,
                    ),
                    SizedBox(height: 10),
                    buildTextField(
                        hint: 'email',
                        icon: Icons.alternate_email_rounded,
                        inputType: TextInputType.emailAddress,
                        ctrl: email),
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
                      title: 'Cadastrar',
                      onTap: () => controller.createUser(
                        context,
                        name.text,
                        email.text,
                        password.text,
                      ),
                    ),
                    Expanded(child: SizedBox()),
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
          },
        ),
      ),
    );
  }
}
