import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/livro.dart';
import '../../domain/usecases/CadastrarLivroUseCase.dart';
import '../../domain/usecases/AtualizarLivroUseCase.dart';

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
          titulo: _tituloController.text,
          autor: _autorController.text,
          categoria: _categoriaController.text,
        );
        await getIt<CadastrarLivroUseCase>().execute(novoLivro);
      } else {
        final livroEditado = widget.livro!.copyWith(
          titulo: _tituloController.text,
          autor: _autorController.text,
          categoria: _categoriaController.text,
        );
        await getIt<AtualizarLivroUseCase>().execute(livroEditado);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livro salvo com sucesso!')),
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
        title: Text(widget.livro == null ? 'Cadastrar Livro' : 'Editar Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Semantics(
                label: 'Título do livro',
                child: TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Autor do livro',
                child: TextFormField(
                  controller: _autorController,
                  decoration: const InputDecoration(labelText: 'Autor'),
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Categoria do livro',
                child: TextFormField(
                  controller: _categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  validator: (v) => v == null || v.isEmpty ? 'Obrigatório' : null,
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _salvar,
                      child: const Text('SALVAR LIVRO'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
