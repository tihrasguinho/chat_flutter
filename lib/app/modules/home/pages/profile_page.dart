import 'package:chat/app/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.isMe, required this.user})
      : super(key: key);

  final bool isMe;
  final UserModel user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        backwardsCompatibility: false,
        centerTitle: true,
        title: Text(widget.user.name),
      ),
    );
  }
}
