// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatStore on _ChatSoreBase, Store {
  final _$inputAtom = Atom(name: '_ChatSoreBase.input');

  @override
  TextEditingController get input {
    _$inputAtom.reportRead();
    return super.input;
  }

  @override
  set input(TextEditingController value) {
    _$inputAtom.reportWrite(value, super.input, () {
      super.input = value;
    });
  }

  final _$replyAtom = Atom(name: '_ChatSoreBase.reply');

  @override
  MessageModel? get reply {
    _$replyAtom.reportRead();
    return super.reply;
  }

  @override
  set reply(MessageModel? value) {
    _$replyAtom.reportWrite(value, super.reply, () {
      super.reply = value;
    });
  }

  final _$emptyAtom = Atom(name: '_ChatSoreBase.empty');

  @override
  bool get empty {
    _$emptyAtom.reportRead();
    return super.empty;
  }

  @override
  set empty(bool value) {
    _$emptyAtom.reportWrite(value, super.empty, () {
      super.empty = value;
    });
  }

  final _$loadingAtom = Atom(name: '_ChatSoreBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$messagesAtom = Atom(name: '_ChatSoreBase.messages');

  @override
  List<MessageModel> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(List<MessageModel> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$sendMessageAsyncAction = AsyncAction('_ChatSoreBase.sendMessage');

  @override
  Future<void> sendMessage(String uid) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(uid));
  }

  final _$sendImageToChatAsyncAction =
      AsyncAction('_ChatSoreBase.sendImageToChat');

  @override
  Future<void> sendImageToChat(String uid) {
    return _$sendImageToChatAsyncAction.run(() => super.sendImageToChat(uid));
  }

  final _$deleteMessageAsyncAction = AsyncAction('_ChatSoreBase.deleteMessage');

  @override
  Future<void> deleteMessage(MessageModel message) {
    return _$deleteMessageAsyncAction.run(() => super.deleteMessage(message));
  }

  final _$markAsSeenAsyncAction = AsyncAction('_ChatSoreBase.markAsSeen');

  @override
  Future<void> markAsSeen() {
    return _$markAsSeenAsyncAction.run(() => super.markAsSeen());
  }

  final _$_ChatSoreBaseActionController =
      ActionController(name: '_ChatSoreBase');

  @override
  dynamic setLoading(bool val) {
    final _$actionInfo = _$_ChatSoreBaseActionController.startAction(
        name: '_ChatSoreBase.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_ChatSoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMessage(MessageModel message) {
    final _$actionInfo = _$_ChatSoreBaseActionController.startAction(
        name: '_ChatSoreBase.removeMessage');
    try {
      return super.removeMessage(message);
    } finally {
      _$_ChatSoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updatedMessage(MessageModel message) {
    final _$actionInfo = _$_ChatSoreBaseActionController.startAction(
        name: '_ChatSoreBase.updatedMessage');
    try {
      return super.updatedMessage(message);
    } finally {
      _$_ChatSoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void insertMessage(MessageModel message) {
    final _$actionInfo = _$_ChatSoreBaseActionController.startAction(
        name: '_ChatSoreBase.insertMessage');
    try {
      return super.insertMessage(message);
    } finally {
      _$_ChatSoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
input: ${input},
reply: ${reply},
empty: ${empty},
loading: ${loading},
messages: ${messages}
    ''';
  }
}
