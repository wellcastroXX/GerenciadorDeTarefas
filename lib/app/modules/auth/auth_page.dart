import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:test_mobile_app/app/database/database_service.dart';
import 'package:test_mobile_app/app/modules/auth/auth_store.dart';
import 'package:test_mobile_app/app/modules/home/home_store.dart';

class AuthPage extends StatefulWidget {
  final String title;
  final AuthStore authStore;
  final HomeStore homeStore;
  const AuthPage({Key? key, required this.authStore, required this.homeStore, this.title = 'AuthPage'}) : super(key: key);
  
  @override
  AuthPageState createState() => AuthPageState();

  void _login(BuildContext context, String email, String password) async {
    final isAuthenticated = await authStore.authenticateUser(email, password);
    if (isAuthenticated) {
      Modular.to.pushReplacementNamed('/home');
    } else {
      //error message or popup
    }
  }

  void _register(String firstname, String lastname, String email, String password) async {
      await authStore.registerUser(firstname, lastname, email, password);
      Modular.to.pushReplacementNamed('/home');
  }
}

class AuthPageState extends State<AuthPage> {
  final AuthStore store = Modular.get();
  bool isLoginView = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8C663),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Text(
              isLoginView ? 'Bem-vindo de volta' : 'Cadastrar-se',
              style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10.0),
            Text(
              isLoginView
                  ? 'Por favor, entre com suas credenciais para fazer login'
                  : 'Por favor, preencha as informações para se cadastrar',
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
            ),
            const SizedBox(height: 30.0),
            if (!isLoginView) ...[
              const SizedBox(height: 10.0),
              TextField(
                controller: firstNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                controller: lastNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Sobrenome',
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 70.0),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.88,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLoginView) {
                      widget._login(context, emailController.text, passwordController.text);
                    } else {
                      widget._register(firstNameController.text, lastNameController.text, emailController.text, passwordController.text,);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16.0),
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    backgroundColor: const Color(0xFFF1EEE7),
                  ),
                  child: Text(isLoginView ? 'Login' : 'Registrar', style: const TextStyle(color: Colors.black38),),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      isLoginView = !isLoginView;
                    });
                  },
                  child: Text(
                    isLoginView
                        ? 'Ainda não tem uma conta? Cadastrar-se'
                        : 'Já tem uma conta? Entrar',
                        style: const TextStyle(color: Colors.black45),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
