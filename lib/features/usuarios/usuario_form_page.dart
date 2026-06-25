import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/usecases/CadastrarUsuarioUseCase.dart';
import '../../domain/usecases/CadastrarEditorUseCase.dart';
import '../../core/constants/app_constants.dart';

class UsuarioFormPage extends StatefulWidget {
  final String perfilInicial; // LEITOR ou EDITOR
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _perfil = args;
    }
  }

  @override
  void initState() {
    super.initState();
    _perfil = widget.perfilInicial;
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

      if (_perfil == AppConstants.profileEditor) {
        await getIt<CadastrarEditorUseCase>().execute(usuario);
      } else {
        await getIt<CadastrarUsuarioUseCase>().execute(usuario);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar $_perfil'),
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
                  validator: (v) => v == null || v.length < 5 ? 'Senha muito curta' : null,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _salvar,
                        child: const Text('CADASTRAR'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
