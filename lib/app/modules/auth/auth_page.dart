import 'dart:ui';

import 'package:chat/app/modules/auth/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final AuthStore store = Modular.get();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    store.checkLoggedUser();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColorDark,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Tween<Offset>(
                          begin: Offset.zero,
                          end: Offset(-size.width, -size.height))
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.easeInOut))
                      .value,
                  child: Column(
                    children: [
                      Expanded(flex: 3, child: SizedBox()),
                      buildTextField(
                        hint: 'Email',
                        icon: Icons.alternate_email_rounded,
                        ctrl: store.email,
                      ),
                      SizedBox(height: 10),
                      buildTextField(
                        hint: 'Password',
                        icon: Icons.lock_rounded,
                        ctrl: store.password,
                        obscure: true,
                      ),
                      SizedBox(height: 10),
                      buildButton(
                        title: 'Sign In',
                        onTap: () => store.signIn(context),
                      ),
                      Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () {
                          if (_controller.isDismissed) {
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }
                        },
                        child: Text(
                          'Sign up a new account!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Tween<Offset>(
                          begin: Offset(size.width, size.height),
                          end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.easeInOut))
                      .value,
                  child: Column(
                    children: [
                      Expanded(flex: 3, child: SizedBox()),
                      buildTextField(
                        hint: 'First Name',
                        icon: Icons.text_fields_rounded,
                        ctrl: store.firstName,
                      ),
                      SizedBox(height: 10),
                      buildTextField(
                        hint: 'Last Name',
                        icon: Icons.text_fields_rounded,
                        ctrl: store.lastName,
                      ),
                      SizedBox(height: 10),
                      buildTextField(
                        hint: 'Email',
                        icon: Icons.alternate_email_rounded,
                        ctrl: store.email,
                      ),
                      SizedBox(height: 10),
                      buildTextField(
                        hint: 'Password',
                        icon: Icons.lock_rounded,
                        obscure: true,
                        ctrl: store.password,
                      ),
                      SizedBox(height: 10),
                      buildButton(
                        title: 'Sign Up',
                        onTap: () => store.createUser(context),
                      ),
                      Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () {
                          if (_controller.isDismissed) {
                            _controller.forward();
                          } else {
                            _controller.reverse();
                          }

                          store.clearInputs();
                        },
                        child: Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Observer(
            builder: (_) {
              return store.loading
                  ? Positioned(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.white60,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    String? hint,
    IconData? icon,
    TextEditingController? ctrl,
    bool obscure = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              SizedBox(width: 15),
              Icon(icon),
              SizedBox(width: 10),
              Flexible(
                child: TextField(
                  obscureText: obscure,
                  controller: ctrl,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint ?? '',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    String? title,
    Function? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Material(
        elevation: 2,
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () => onTap!(),
          highlightColor: Colors.black12,
          splashColor: Colors.black12,
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
