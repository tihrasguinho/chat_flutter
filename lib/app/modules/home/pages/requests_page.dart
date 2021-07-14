import 'package:chat/app/modules/home/stores/requests_store.dart';
import 'package:chat/app/modules/home/widgets/user_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({
    Key? key,
  }) : super(key: key);

  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  final RequestsStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        title: Text(
          'Solicitações de amizade',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          padding: EdgeInsets.only(top: 5),
          itemCount: store.requests.length,
          itemBuilder: (_, i) {
            var item = store.requests[i];

            return UserView(
              item: item,
              onPressed: () => Modular.to.popAndPushNamed(
                '/home/profile',
                arguments: {
                  'isMe': false,
                  'user': item,
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
