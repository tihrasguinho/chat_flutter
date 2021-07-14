import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/modules/home/stores/profile_store.dart';
import 'package:chat/app/modules/home/widgets/buttom_custom.dart';
import 'package:chat/app/shared/functions/get_empty_image_url.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.isMe, required this.user})
      : super(key: key);

  final bool isMe;
  final UserModel user;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ModularState<ProfilePage, ProfileStore> {
  final HomeStore home = Modular.get();

  void popUpImage(BuildContext context) async {
    if (widget.isMe) {
      if (home.user.image!.isEmpty) return;
    } else {
      if (widget.user.image!.isEmpty) return;
    }

    await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            widget.isMe ? home.user.image! : widget.user.image!,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // if (!widget.isMe) store.hasRequest(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        backwardsCompatibility: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Modular.to.pop(),
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          'Perfil',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Observer(
            builder: (_) {
              return Stack(
                children: [
                  InkWell(
                    onTap: () => popUpImage(context),
                    borderRadius: BorderRadius.circular(90),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.white,
                      backgroundImage: widget.isMe
                          ? NetworkImage(
                              home.user.image!.isEmpty
                                  ? getEmptyImageUrl(
                                      home.user.name!.replaceAll(' ', '+'))
                                  : home.user.image!,
                            )
                          : NetworkImage(
                              widget.user.image!.isEmpty
                                  ? getEmptyImageUrl(
                                      widget.user.name!.replaceAll(' ', '+'))
                                  : widget.user.image!,
                            ),
                    ),
                  ),
                  store.loading
                      ? Positioned.fill(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      : SizedBox(),
                  store.loading
                      ? SizedBox()
                      : Positioned(
                          bottom: 0,
                          right: 0,
                          child: widget.isMe
                              ? Material(
                                  color: Theme.of(context).primaryColor,
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(45),
                                  child: InkWell(
                                    onTap: () => store.changeImage(),
                                    borderRadius: BorderRadius.circular(45),
                                    splashColor: Colors.black12,
                                    highlightColor: Colors.black12,
                                    child: SizedBox(
                                      height: 42,
                                      width: 42,
                                      child: Center(
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ),
                ],
              );
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isMe ? home.user.name! : widget.user.name!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isMe ? home.user.email! : widget.user.email!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Observer(
            builder: (_) {
              return store.showBtn
                  ? Row(
                      children: [
                        Expanded(
                          child: ButtonCustom(
                            context: context,
                            title: 'Aceitar',
                            onTap: () => store.acceptFriendship(),
                          ),
                        ),
                        Expanded(
                          child: ButtonCustom(
                            context: context,
                            title: 'Rejeitar',
                            backgroundColor: Colors.red,
                            onTap: () {},
                          ),
                        ),
                      ],
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
