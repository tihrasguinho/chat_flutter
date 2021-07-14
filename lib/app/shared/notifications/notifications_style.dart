import 'dart:convert';

import 'package:chat/app/shared/notifications/notifications_helpers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> buildFriendAcceptedNofification(
  RemoteMessage message,
  FlutterLocalNotificationsPlugin plugin,
) async {
  final senderMap = jsonDecode(message.data['sender']) as Map;

  final String largeIconPath =
      await downloadAndSaveFile(senderMap['image'], 'largeIcon');

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'friend_accepted',
    'Friend Accepted Channel',
    'Channel to show friend requests response!',
    priority: Priority.high,
    importance: Importance.max,
    largeIcon: FilePathAndroidBitmap(largeIconPath),
  );

  final NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await plugin.show(
    0,
    'Solicitação de amizade aceita',
    '${senderMap['name']} aceitou seu pedido de amizade!',
    details,
    payload: 'FRIEND_ACCEPTED*${message.data['sender']}',
  );
}

// Build friend request notification style

Future<void> buildFriendRequestNofification(
  RemoteMessage message,
  FlutterLocalNotificationsPlugin plugin,
) async {
  final senderMap = jsonDecode(message.data['sender']) as Map;

  final String largeIconPath =
      await downloadAndSaveFile(senderMap['image'], 'largeIcon');

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'friend_request',
    'Friend Request Channel',
    'Channel to new friend requests notification!',
    priority: Priority.high,
    importance: Importance.max,
    largeIcon: FilePathAndroidBitmap(largeIconPath),
  );

  final NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await plugin.show(
    0,
    'Solicitação de amizade recebida',
    '${senderMap['name']} enviou um pedido de amizade!',
    details,
    payload: 'FRIEND_REQUEST*${message.data['sender']}',
  );
}

// Default chat notification style

Future<void> buildChatDefaultNofification(
  RemoteMessage message,
  FlutterLocalNotificationsPlugin plugin,
) async {
  final messageMap = jsonDecode(message.data['message']) as Map;

  final senderMap = jsonDecode(message.data['sender']) as Map;

  var encodedPayload = jsonEncode({...senderMap, 'key': messageMap['key']});

  final String largeIconPath =
      await downloadAndSaveFile(senderMap['image'], 'largeIcon');

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'text_message',
    'Text Message Channel',
    'Channel to show text messages only!',
    priority: Priority.high,
    importance: Importance.max,
    largeIcon: FilePathAndroidBitmap(largeIconPath),
  );

  final NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await plugin.show(
    0,
    '${senderMap['name']}',
    '${messageMap['message']}',
    details,
    payload: 'NEW_MESSAGE*$encodedPayload',
  );
}

// Big picture chat notification style for messages

Future<void> buildChatBigPictureNotification(
  RemoteMessage message,
  FlutterLocalNotificationsPlugin plugin,
) async {
  final messageMap = jsonDecode(message.data['message']) as Map;

  final senderMap = jsonDecode(message.data['sender']) as Map;

  var encodedPayload = jsonEncode({...senderMap, 'key': messageMap['key']});

  final String largeIconPath =
      await downloadAndSaveFile(senderMap['image'], 'largeIcon');

  final String bigPicturePath =
      await downloadAndSaveFile(messageMap['message'], 'bigPicture');

  final BigPictureStyleInformation bigPictureStyleInformation =
      BigPictureStyleInformation(
    FilePathAndroidBitmap(bigPicturePath),
    hideExpandedLargeIcon: true,
    htmlFormatContentTitle: true,
    htmlFormatSummaryText: true,
    contentTitle: '<b>Flutter Chat App</b>',
    summaryText: '<b>${senderMap['name']}</b> enviou uma imagem!',
  );

  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'big_text_channel',
    'Big Text Channel',
    'Channel to show notifications with images!',
    priority: Priority.high,
    importance: Importance.max,
    largeIcon: FilePathAndroidBitmap(largeIconPath),
    styleInformation: bigPictureStyleInformation,
  );

  final NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await plugin.show(
    0,
    '${senderMap['name']}',
    'Enviou uma imagem!',
    notificationDetails,
    payload: 'NEW_MESSAGE*$encodedPayload',
  );
}
