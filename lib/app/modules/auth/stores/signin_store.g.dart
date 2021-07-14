// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SigninStore on _SigninStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_SigninStoreBase.loading'))
      .value;
  Computed<bool>? _$otherComputed;

  @override
  bool get other => (_$otherComputed ??=
          Computed<bool>(() => super.other, name: '_SigninStoreBase.other'))
      .value;

  final _$_otherConnectionsAtom =
      Atom(name: '_SigninStoreBase._otherConnections');

  @override
  bool get _otherConnections {
    _$_otherConnectionsAtom.reportRead();
    return super._otherConnections;
  }

  @override
  set _otherConnections(bool value) {
    _$_otherConnectionsAtom.reportWrite(value, super._otherConnections, () {
      super._otherConnections = value;
    });
  }

  final _$_isLoadingAtom = Atom(name: '_SigninStoreBase._isLoading');

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  final _$signInAsyncAction = AsyncAction('_SigninStoreBase.signIn');

  @override
  Future<dynamic> signIn(BuildContext context, String email, String password) {
    return _$signInAsyncAction
        .run(() => super.signIn(context, email, password));
  }

  final _$_SigninStoreBaseActionController =
      ActionController(name: '_SigninStoreBase');

  @override
  dynamic setLoading() {
    final _$actionInfo = _$_SigninStoreBaseActionController.startAction(
        name: '_SigninStoreBase.setLoading');
    try {
      return super.setLoading();
    } finally {
      _$_SigninStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOtherConnections() {
    final _$actionInfo = _$_SigninStoreBaseActionController.startAction(
        name: '_SigninStoreBase.setOtherConnections');
    try {
      return super.setOtherConnections();
    } finally {
      _$_SigninStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
other: ${other}
    ''';
  }
}
