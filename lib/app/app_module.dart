import 'package:flutter_modular/flutter_modular.dart';
import 'modules/auth/auth_module.dart';
import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute('/', module: AuthModule()),
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];

}