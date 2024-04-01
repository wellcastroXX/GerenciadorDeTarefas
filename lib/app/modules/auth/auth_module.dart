import 'package:test_mobile_app/app/database/database_service.dart';
import 'package:test_mobile_app/app/modules/auth/auth_page.dart';
import 'package:test_mobile_app/app/modules/auth/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:test_mobile_app/app/modules/home/home_store.dart';
import '../home/home_page.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => AuthStore()),
    Bind.lazySingleton((i) => DatabaseService()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      '/',
      child: (_, args) => AuthPage(
        authStore: Modular.get<AuthStore>(),
        homeStore: HomeStore(Modular.get<DatabaseService>()),
      ),
    ),
    ChildRoute('/home', child: (_, __) => const HomePage()),
  ];
}
