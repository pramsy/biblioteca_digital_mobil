import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/CadastrarUsuarioUseCase.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validator_helper.dart';

class UsuarioFormPage extends StatefulWidget {
  final String perfilInicial;
  const UsuarioFormPage({super.key, this.perfilInicial = AppConstants.profileLeitor});

  @override
  State<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  late String _perfil;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _perfil = widget.perfilInicial;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _perfil = args;
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final usuario = Usuario(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        senha: _senhaController.text,
        perfil: _perfil,
      );

      await getIt<CadastrarUsuarioUseCase>().execute(usuario);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sucesso: $_perfil cadastrado corretamente.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String msg = e.toString().replaceAll('Exception: ', '');
        if (msg.contains('E-mail já cadastrado')) {
          msg = 'Conflito: E-mail em uso. Intervenção: Use outro e-mail ou recupere sua senha.';
        } else if (msg.contains('senha deve ter no mínimo')) {
          msg = 'Segurança fraca. Intervenção: Use pelo menos 8 caracteres com letras e números.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ação necessária: $msg'),
            backgroundColor: Colors.red[700],
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
    String label = _perfil == AppConstants.profileLeitor ? 'Leitor' : 
                   _perfil == AppConstants.profileBibliotecario ? 'Bibliotecário' : 'Administrador';

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar $label'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Preencha as informações abaixo para criar a conta.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                    hintText: 'Ex: João Silva',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: ValidatorHelper.validarNome,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'exemplo@biblioteca.com',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidatorHelper.validarEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Mínimo 8 caracteres (letras e números)',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: ValidatorHelper.validarSenha,
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _salvar,
                        child: Text('FINALIZAR CADASTRO DE $label'.toUpperCase()),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
