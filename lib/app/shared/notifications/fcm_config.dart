import 'dart:convert';

import 'package:chat/app/shared/models/user_model.dart';
import 'package:chat/app/shared/notifications/notifications_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';

// Start flutter local notifications plugin

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Android settings

const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('chat');

// iOs settings

const IOSInitializationSettings iosInitializationSettings =
    IOSInitializationSettings();

// Mac settings

const MacOSInitializationSettings macOSInitializationSettings =
    MacOSInitializationSettings();

// Initial settings

final InitializationSettings initializationSettings = InitializationSettings(
  android: androidInitializationSettings,
  iOS: iosInitializationSettings,
  macOS: macOSInitializationSettings,
);

// Build notification

void _buildNotification(RemoteMessage message) async {
  var type = message.data['type'];

  switch (type) {
    case 'NEW_MESSAGE':
      {
        var sender = jsonDecode(message.data['sender']) as Map;

        // verifying if the current screen to cancel notification

        if (Modular.to.path.contains('chat/${sender['uid']}')) {
          flutterLocalNotificationsPlugin.cancel(message.hashCode);
          break;
        }

        var data = jsonDecode(message.data['message']);

        var isImage = data['type'] == 'image';

        if (isImage) {
          await buildChatBigPictureNotification(
            message,
            flutterLocalNotificationsPlugin,
          );
        } else {
          await buildChatDefaultNofification(
            message,
            flutterLocalNotificationsPlugin,
          );
        }

        break;
      }
    case 'FRIEND_REQUEST':
      {
        await buildFriendRequestNofification(
          message,
          flutterLocalNotificationsPlugin,
        );

        break;
      }
    case 'FRIEND_ACCEPTED':
      {
        await buildFriendAcceptedNofification(
          message,
          flutterLocalNotificationsPlugin,
        );

        break;
      }
    default:
      {
        flutterLocalNotificationsPlugin.cancel(message.hashCode);

        break;
      }
  }
}

// On selected notification

Future _onSelectedNotification(String payload) async {
  var splited = payload.split('*');

  switch (splited[0]) {
    case 'NEW_MESSAGE':
      {
        var user = UserModel.fromMap(jsonDecode(splited[1]));

        return Modular.to.pushNamed(
          '/home/chat/${user.uid}',
          arguments: {
            'friend': user,
          },
        );
      }
    case 'FRIEND_REQUEST':
      {
        var user = UserModel.fromMap(jsonDecode(splited[1]));

        return Modular.to.pushNamed(
          '/home/profile',
          arguments: {
            'isMe': false,
            'user': user,
          },
        );
      }
    case 'FRIEND_ACCEPTED':
      {
        var user = UserModel.fromMap(jsonDecode(splited[1]));

        return Modular.to.pushNamed(
          '/home/profile',
          arguments: {
            'isMe': false,
            'user': user,
          },
        );
      }
    default:
      {
        return Modular.to.pushNamed('/');
      }
  }
}

// Background handler notifications

Future<void> _onBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _buildNotification(message);
}

class FCMConfig {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) => _onSelectedNotification(payload!),
    );

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);

    FirebaseMessaging.onMessage.listen(_buildNotification);
  }
}
