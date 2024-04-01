// home_module.dart
import 'package:flutter_modular/flutter_modular.dart';
import 'package:test_mobile_app/app/database/database_service.dart';
import 'package:test_mobile_app/app/modules/home/home_page.dart';
import 'package:test_mobile_app/app/modules/home/home_store.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => HomeStore(DatabaseService())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/home', child: (_, __) => const HomePage()),
  ];
}
