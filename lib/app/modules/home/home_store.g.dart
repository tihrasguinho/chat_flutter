// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStoreBase, Store {
  Computed<bool>? _$showComputed;

  @override
  bool get show => (_$showComputed ??=
          Computed<bool>(() => super.show, name: '_HomeStoreBase.show'))
      .value;

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
show: ${show}
    ''';
  }
}
