// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileStore on _ProfileStoreBase, Store {
  Computed<bool>? _$showBtnComputed;

  @override
  bool get showBtn => (_$showBtnComputed ??= Computed<bool>(() => super.showBtn,
          name: '_ProfileStoreBase.showBtn'))
      .value;
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??= Computed<bool>(() => super.loading,
          name: '_ProfileStoreBase.loading'))
      .value;

  final _$_showAcceptButtonAtom =
      Atom(name: '_ProfileStoreBase._showAcceptButton');

  @override
  bool get _showAcceptButton {
    _$_showAcceptButtonAtom.reportRead();
    return super._showAcceptButton;
  }

  @override
  set _showAcceptButton(bool value) {
    _$_showAcceptButtonAtom.reportWrite(value, super._showAcceptButton, () {
      super._showAcceptButton = value;
    });
  }

  final _$_loadingAtom = Atom(name: '_ProfileStoreBase._loading');

  @override
  bool get _loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  final _$acceptFriendshipAsyncAction =
      AsyncAction('_ProfileStoreBase.acceptFriendship');

  @override
  Future<void> acceptFriendship() {
    return _$acceptFriendshipAsyncAction.run(() => super.acceptFriendship());
  }

  final _$changeImageAsyncAction = AsyncAction('_ProfileStoreBase.changeImage');

  @override
  Future<void> changeImage() {
    return _$changeImageAsyncAction.run(() => super.changeImage());
  }

  final _$_ProfileStoreBaseActionController =
      ActionController(name: '_ProfileStoreBase');

  @override
  dynamic setLoading(bool val) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showBtn: ${showBtn},
loading: ${loading}
    ''';
  }
}
