// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthStore on _AuthStoreBase, Store {
  Computed<bool>? _$loadingComputed;

  @override
  bool get loading => (_$loadingComputed ??=
          Computed<bool>(() => super.loading, name: '_AuthStoreBase.loading'))
      .value;

  final _$_loadingAtom = Atom(name: '_AuthStoreBase._loading');

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

  final _$firstNameAtom = Atom(name: '_AuthStoreBase.firstName');

  @override
  TextEditingController get firstName {
    _$firstNameAtom.reportRead();
    return super.firstName;
  }

  @override
  set firstName(TextEditingController value) {
    _$firstNameAtom.reportWrite(value, super.firstName, () {
      super.firstName = value;
    });
  }

  final _$lastNameAtom = Atom(name: '_AuthStoreBase.lastName');

  @override
  TextEditingController get lastName {
    _$lastNameAtom.reportRead();
    return super.lastName;
  }

  @override
  set lastName(TextEditingController value) {
    _$lastNameAtom.reportWrite(value, super.lastName, () {
      super.lastName = value;
    });
  }

  final _$emailAtom = Atom(name: '_AuthStoreBase.email');

  @override
  TextEditingController get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(TextEditingController value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$passwordAtom = Atom(name: '_AuthStoreBase.password');

  @override
  TextEditingController get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(TextEditingController value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$checkLoggedUserAsyncAction =
      AsyncAction('_AuthStoreBase.checkLoggedUser');

  @override
  Future<dynamic> checkLoggedUser() {
    return _$checkLoggedUserAsyncAction.run(() => super.checkLoggedUser());
  }

  final _$signInAsyncAction = AsyncAction('_AuthStoreBase.signIn');

  @override
  Future<dynamic> signIn(BuildContext context) {
    return _$signInAsyncAction.run(() => super.signIn(context));
  }

  final _$createUserAsyncAction = AsyncAction('_AuthStoreBase.createUser');

  @override
  Future<dynamic> createUser(BuildContext context) {
    return _$createUserAsyncAction.run(() => super.createUser(context));
  }

  final _$_AuthStoreBaseActionController =
      ActionController(name: '_AuthStoreBase');

  @override
  dynamic setLoading() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setLoading');
    try {
      return super.setLoading();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearInputs() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.clearInputs');
    try {
      return super.clearInputs();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
firstName: ${firstName},
lastName: ${lastName},
email: ${email},
password: ${password},
loading: ${loading}
    ''';
  }
}
