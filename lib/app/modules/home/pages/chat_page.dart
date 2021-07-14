import 'package:chat/app/modules/home/home_store.dart';
import 'package:chat/app/modules/home/stores/chat_store.dart';
import 'package:chat/app/modules/home/widgets/bubble_chat.dart';
import 'package:chat/app/shared/functions/get_empty_image_url.dart';
import 'package:chat/app/shared/models/message_model.dart';
import 'package:chat/app/shared/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.friend,
    required this.uid,
  }) : super(key: key);

  final UserModel friend;
  final String uid;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ModularState<ChatPage, ChatStore> {
  final HomeStore home = Modular.get();

  void popUpImage(MessageModel item) async {
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.transparent,
        child: Image.network(
          item.message,
          fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }

  void deleteMessage(BuildContext context, MessageModel item) async {
    if (item.from == home.user.uid) {
      await showDialog(
        context: context,
        builder: (_) {
          return Center(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    right: 15,
                    left: 15,
                  ),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    elevation: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Text(
                            'Deseja apagar esta mensagem?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 0),
                        Material(
                          color: Theme.of(context).primaryColor,
                          elevation: 5,
                          borderRadius: BorderRadius.circular(25),
                          child: InkWell(
                            splashColor: Colors.black12,
                            highlightColor: Colors.black12,
                            borderRadius: BorderRadius.circular(25),
                            onTap: () => controller.deleteMessage(item),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 30,
                              ),
                              child: Text(
                                'Sim!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Material(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(45),
                    child: SizedBox(
                      height: 42,
                      width: 42,
                      child: Icon(
                        Icons.priority_high_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void editMessage(BuildContext context, MessageModel item) async {
    if (item.from == home.user.uid && item.type == 'text') {
      store.input.text = item.message;

      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: 75,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: TextField(
                      controller: store.input,
                      minLines: 1,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Material(
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      onTap: () => controller.editMessage(item),
                      splashColor: Colors.black12,
                      highlightColor: Colors.black12,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(
                            'Editar',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      store.input.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Modular.to.pop(),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(Icons.arrow_back_rounded),
                    SizedBox(width: 2),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        widget.friend.image!.isEmpty
                            ? getEmptyImageUrl(
                                widget.friend.name!.replaceAll(' ', '+'))
                            : widget.friend.image!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () => Modular.to.pushNamed(
                '/home/profile',
                arguments: {
                  'isMe': false,
                  'user': widget.friend,
                },
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text(
                widget.friend.name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Observer(
            builder: (_) => Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: controller.messages.length,
                itemBuilder: (_, i) {
                  var item = controller.messages[i];
                  var isMe = item.from == home.user.uid;

                  return BubbleChat(
                    isMe: isMe,
                    item: item,
                    onImagePressed: () => popUpImage(item),
                    onLongPress: () => deleteMessage(context, item),
                    onDoubleTap: () => editMessage(context, item),
                  );
                },
              ),
            ),
          ),
          Material(
            color: Colors.white,
            elevation: 5,
            child: Column(
              children: [
                Observer(
                  builder: (_) {
                    return store.loading
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            minHeight: 2,
                          )
                        : SizedBox(height: 2);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 3,
                    bottom: 5,
                    right: 5,
                    left: 5,
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: store.input,
                          minLines: 1,
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            border: InputBorder.none,
                            hintText: 'Escreva algo...',
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          await controller.sendImageToChat(widget.friend.uid!);
                        },
                        icon: Icon(
                          Icons.attach_file_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      Observer(
                        builder: (_) {
                          return IconButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              await controller.sendMessage(widget.friend.uid!);
                            },
                            icon: Icon(
                              store.empty
                                  ? Icons.mic_rounded
                                  : Icons.send_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
