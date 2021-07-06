// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStoreBase, Store {
  Computed<String>? _$uidComputed;

  @override
  String get uid => (_$uidComputed ??=
          Computed<String>(() => super.uid, name: '_HomeStoreBase.uid'))
      .value;
  Computed<bool>? _$showComputed;

  @override
  bool get show => (_$showComputed ??=
          Computed<bool>(() => super.show, name: '_HomeStoreBase.show'))
      .value;

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

  final _$previewAtom = Atom(name: '_HomeStoreBase.preview');

  @override
  List<MessagePreview> get preview {
    _$previewAtom.reportRead();
    return super.preview;
  }

  @override
  set preview(List<MessagePreview> value) {
    _$previewAtom.reportWrite(value, super.preview, () {
      super.preview = value;
    });
  }

  final _$_showAtom = Atom(name: '_HomeStoreBase._show');

  @override
  bool get _show {
    _$_showAtom.reportRead();
    return super._show;
  }

  @override
  set _show(bool value) {
    _$_showAtom.reportWrite(value, super._show, () {
      super._show = value;
    });
  }

  final _$loadLastMessagesAsyncAction =
      AsyncAction('_HomeStoreBase.loadLastMessages');

  @override
  Future loadLastMessages() {
    return _$loadLastMessagesAsyncAction.run(() => super.loadLastMessages());
  }

  final _$getCurrentUserAsyncAction =
      AsyncAction('_HomeStoreBase.getCurrentUser');

  @override
  Future<dynamic> getCurrentUser() {
    return _$getCurrentUserAsyncAction.run(() => super.getCurrentUser());
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
  dynamic setShow() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.setShow');
    try {
      return super.setShow();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
preview: ${preview},
uid: ${uid},
show: ${show}
    ''';
  }
}
