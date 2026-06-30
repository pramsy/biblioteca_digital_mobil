import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/livro.dart';
import '../../domain/usecases/CadastrarLivroUseCase.dart';
import '../../domain/usecases/AtualizarLivroUseCase.dart';
import '../../core/utils/validator_helper.dart';

class LivroFormPage extends StatefulWidget {
  final Livro? livro;
  const LivroFormPage({super.key, this.livro});

  @override
  State<LivroFormPage> createState() => _LivroFormPageState();
}

class _LivroFormPageState extends State<LivroFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _categoriaController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro?.titulo);
    _autorController = TextEditingController(text: widget.livro?.autor);
    _categoriaController = TextEditingController(text: widget.livro?.categoria);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (widget.livro == null) {
        final novoLivro = Livro(
          titulo: _tituloController.text.trim(),
          autor: _autorController.text.trim(),
          categoria: _categoriaController.text.trim(),
        );
        await getIt<CadastrarLivroUseCase>().execute(novoLivro);
      } else {
        final livroEditado = widget.livro!.copyWith(
          titulo: _tituloController.text.trim(),
          autor: _autorController.text.trim(),
          categoria: _categoriaController.text.trim(),
        );
        await getIt<AtualizarLivroUseCase>().execute(livroEditado);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sucesso: O catálogo foi atualizado com o novo livro.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
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
      appBar: AppBar(
        title: Text(widget.livro == null ? 'Cadastrar Livro' : 'Editar Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                label: 'Título do livro para identificação no acervo',
                child: TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título do Livro',
                    hintText: 'Ex: Dom Casmurro',
                  ),
                  validator: (v) => ValidatorHelper.validarObrigatorio(v, 'Título'),
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Nome do autor ou responsável pela obra',
                child: TextFormField(
                  controller: _autorController,
                  decoration: const InputDecoration(
                    labelText: 'Autor',
                    hintText: 'Ex: Machado de Assis',
                  ),
                  validator: (v) => ValidatorHelper.validarObrigatorio(v, 'Autor'),
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Gênero ou categoria literária',
                child: TextFormField(
                  controller: _categoriaController,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    hintText: 'Ex: Romance, Suspense, Técnico',
                  ),
                  validator: (v) => ValidatorHelper.validarObrigatorio(v, 'Categoria'),
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _salvar,
                      child: const Text('SALVAR NO ACERVO'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
