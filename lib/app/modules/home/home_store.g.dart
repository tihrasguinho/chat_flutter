// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStoreBase, Store {
  final _$userAtom = Atom(name: '_HomeStoreBase.user');

  @override
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$isDialOpenAtom = Atom(name: '_HomeStoreBase.isDialOpen');

  @override
  ValueNotifier<bool> get isDialOpen {
    _$isDialOpenAtom.reportRead();
    return super.isDialOpen;
  }

  @override
  set isDialOpen(ValueNotifier<bool> value) {
    _$isDialOpenAtom.reportWrite(value, super.isDialOpen, () {
      super.isDialOpen = value;
    });
  }

  final _$requestsCountAtom = Atom(name: '_HomeStoreBase.requestsCount');

  @override
  int get requestsCount {
    _$requestsCountAtom.reportRead();
    return super.requestsCount;
  }

  @override
  set requestsCount(int value) {
    _$requestsCountAtom.reportWrite(value, super.requestsCount, () {
      super.requestsCount = value;
    });
  }

  final _$messagesPreviewAtom = Atom(name: '_HomeStoreBase.messagesPreview');

  @override
  List<MessagePreview> get messagesPreview {
    _$messagesPreviewAtom.reportRead();
    return super.messagesPreview;
  }

  @override
  set messagesPreview(List<MessagePreview> value) {
    _$messagesPreviewAtom.reportWrite(value, super.messagesPreview, () {
      super.messagesPreview = value;
    });
  }

  final _$signOutAsyncAction = AsyncAction('_HomeStoreBase.signOut');

  @override
  Future signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  final _$addFriendAsyncAction = AsyncAction('_HomeStoreBase.addFriend');

  @override
  Future addFriend(BuildContext context) {
    return _$addFriendAsyncAction.run(() => super.addFriend(context));
  }

  final _$_HomeStoreBaseActionController =
      ActionController(name: '_HomeStoreBase');

  @override
  void openDial() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.openDial');
    try {
      return super.openDial();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateRequestsCount(int val) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.updateRequestsCount');
    try {
      return super.updateRequestsCount(val);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updateUser({String? name, String? email, String? image}) {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.updateUser');
    try {
      return super.updateUser(name: name, email: email, image: image);
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
isDialOpen: ${isDialOpen},
requestsCount: ${requestsCount},
messagesPreview: ${messagesPreview}
    ''';
  }
}
