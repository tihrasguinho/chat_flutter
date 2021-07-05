import 'dart:convert';

import 'package:chat/app/shared/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';

final channelId = 'chat_app_max';
final channelName = 'Chat App Max';
final channelDescription = 'Chat App Channel Max';
final groupKey = 'dev.tihrasguinho.chat';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final channel = AndroidNotificationChannel(
  channelId,
  channelName,
  channelDescription,
  importance: Importance.max,
  enableVibration: true,
  showBadge: true,
);

final androidPlatformChannelSpecifics = AndroidNotificationDetails(
  channelId,
  channelName,
  channelDescription,
  groupKey: groupKey,
  importance: Importance.max,
  priority: Priority.high,
  showWhen: false,
);

final notificationsDetails = NotificationDetails(
  android: androidPlatformChannelSpecifics,
);

final initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

final initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

show(int id, String title, String body, String payload) =>
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationsDetails,
      payload: payload,
    );

Future onSelected(String payload) async {
  var split = payload.split('/');

  switch (split[0]) {
    case 'FRIEND_REQUEST':
      {
        var map = jsonDecode(split[1]);

        return Modular.to.pushNamed('/home/profile', arguments: {
          'isMe': false,
          'user': UserModel(
            uid: map['uid'],
            name: map['name'],
            image: map['image'],
            email: map['email'],
            friends: [],
            since: map['since'],
          ),
        });
      }
    case 'FRIEND_ACCEPTED':
      {
        var map = jsonDecode(split[1]);

        return Modular.to.pushNamed('/home/profile', arguments: {
          'isMe': false,
          'user': UserModel(
            uid: map['uid'],
            name: map['name'],
            image: map['image'],
            email: map['email'],
            friends: [],
            since: map['since'],
          ),
        });
      }
    default:
      {
        return Modular.to.pushNamed('/home');
      }
  }
}

Future<void> notificationBuiler(RemoteMessage message) async {
  switch (message.data['type']) {
    case 'FRIEND_REQUEST':
      {
        final map = json.decode(message.data['sender']);

        final title = 'Novo pedido de amizade';
        final body = '${map['name']} deseja ser seu amigo!';
        final payload = 'FRIEND_REQUEST/${message.data['sender']}';

        return show(
          message.hashCode,
          title,
          body,
          payload,
        );
      }
    case 'FRIEND_ACCEPTED':
      {
        final map = json.decode(message.data['sender']);

        final title = 'Pedido de amizade aceito';
        final body = '${map['name']} aceitou seu pedido de amizade!';
        final payload = 'FRIEND_ACCEPTED/${message.data['sender']}';

        return show(
          message.hashCode,
          title,
          body,
          payload,
        );
      }
    default:
      {
        return flutterLocalNotificationsPlugin.cancel(message.hashCode);
      }
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  return notificationBuiler(message);
}

class NotificationsRepository {
  NotificationsRepository() {
    initialize();
  }

  void initialize() async {
    await FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    )
        .then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    }).catchError((err) {
      print(err);
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async => await onSelected(payload!),
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen(notificationBuiler);
  }
}
