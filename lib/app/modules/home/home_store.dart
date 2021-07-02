import 'package:chat/app/shared/repositories/api_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_store.g.dart';

class HomeStore = HomeStoreBase with _$HomeStore;

abstract class HomeStoreBase with Store {
  final repository = ApiRepository();

  @action
  updateToken() async {
    var data = await repository.refreshToken();
  }

  @action
  signOut() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.remove('user');
  }
}
