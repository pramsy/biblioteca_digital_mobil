import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/CadastrarUsuarioUseCase.dart';
import '../../core/constants/app_constants.dart';

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
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        perfil: _perfil,
      );

      await getIt<CadastrarUsuarioUseCase>().execute(usuario);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$_perfil cadastrado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
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
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Mínimo 8 caracteres, letra e número',
                  ),
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Obrigatório';
                    if (v.length < 8) return 'Mínimo 8 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _salvar,
                        child: Text('CADASTRAR $label'.toUpperCase()),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
