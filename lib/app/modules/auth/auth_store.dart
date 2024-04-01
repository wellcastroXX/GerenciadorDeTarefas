import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:test_mobile_app/app/database/database_service.dart';
import 'package:test_mobile_app/app/database/models.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;
abstract class _AuthStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }

  String hashPassword(String password) {
     return md5.convert(utf8.encode(password)).toString();
  }

  final _database = Modular.get<DatabaseService>();

  Future<void> registerUser(String firstname, String lastname, String email, String password) async {
    final user = User(firstname: firstname, lastname: lastname, email: email, password: password);
    await _database.registerUser(user);
  }

  Future<bool> authenticateUser(String email, String password) async {
    final user = await _database.authenticateUser(email, password);
    return user != null;
  }
}