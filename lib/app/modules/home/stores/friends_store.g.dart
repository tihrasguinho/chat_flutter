// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FriendsStore on _FriendsStoreBase, Store {
  final _$isEmptyAtom = Atom(name: '_FriendsStoreBase.isEmpty');

  @override
  bool get isEmpty {
    _$isEmptyAtom.reportRead();
    return super.isEmpty;
  }

  @override
  set isEmpty(bool value) {
    _$isEmptyAtom.reportWrite(value, super.isEmpty, () {
      super.isEmpty = value;
    });
  }

  final _$friendsAtom = Atom(name: '_FriendsStoreBase.friends');

  @override
  List<UserModel> get friends {
    _$friendsAtom.reportRead();
    return super.friends;
  }

  @override
  set friends(List<UserModel> value) {
    _$friendsAtom.reportWrite(value, super.friends, () {
      super.friends = value;
    });
  }

  final _$_FriendsStoreBaseActionController =
      ActionController(name: '_FriendsStoreBase');

  @override
  dynamic setEmpty(bool val) {
    final _$actionInfo = _$_FriendsStoreBaseActionController.startAction(
        name: '_FriendsStoreBase.setEmpty');
    try {
      return super.setEmpty(val);
    } finally {
      _$_FriendsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void insertIntoFriends(UserModel user) {
    final _$actionInfo = _$_FriendsStoreBaseActionController.startAction(
        name: '_FriendsStoreBase.insertIntoFriends');
    try {
      return super.insertIntoFriends(user);
    } finally {
      _$_FriendsStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isEmpty: ${isEmpty},
friends: ${friends}
    ''';
  }
}
