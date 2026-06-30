import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../core/services/AuthService.dart';
import '../../app/routes/app_routes.dart';
import '../../core/utils/validator_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await getIt<AuthService>().login(
        _emailController.text.trim(),
        _senhaController.text,
      );
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
      }
    } catch (e) {
      if (mounted) {
        String msg = e.toString().replaceAll('Exception: ', '');
        if (msg.contains('RateLimit')) {
          msg = 'Muitas tentativas. Intervenção: Aguarde 1 minuto para nova tentativa por segurança.';
        } else if (msg.contains('Credenciais inválidas')) {
          msg = 'Credenciais incorretas. Intervenção: Verifique seu e-mail e senha digitados.';
        } else if (msg.contains('Usuário inativo')) {
          msg = 'Conta desativada. Intervenção: Entre em contato com a administração.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text(msg)),
              ],
            ),
            backgroundColor: Colors.red[900],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acesso ao Sistema')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.menu_book, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 32),
              Semantics(
                label: 'Campo para digitar seu e-mail',
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail cadastrado',
                    hintText: 'Digite seu e-mail',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidatorHelper.validarEmail,
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Campo para digitar sua senha',
                child: TextFormField(
                  controller: _senhaController,
                  decoration: const InputDecoration(
                    labelText: 'Senha de acesso',
                    hintText: 'Digite sua senha',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (v) => ValidatorHelper.validarObrigatorio(v, 'Senha'),
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Semantics(
                          label: 'Clique aqui para entrar no sistema',
                          child: ElevatedButton(
                            onPressed: _login,
                            child: const Text('ENTRAR AGORA'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.usuarioForm),
                          child: const Text('Não possui conta? Cadastre-se como Leitor'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
