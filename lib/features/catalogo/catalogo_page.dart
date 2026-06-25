import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/livro.dart';
import '../../domain/repositories/livro_repository.dart';
import '../../domain/usecases/RegistrarEmprestimoUseCase.dart';
import '../../core/services/AuthService.dart';
import '../../app/routes/app_routes.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  final _searchController = TextEditingController();
  List<Livro> _livros = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros([String query = '']) async {
    setState(() => _isLoading = true);
    final repository = getIt<LivroRepository>();
    if (query.isEmpty) {
      _livros = await repository.getAllLivros();
    } else {
      _livros = await repository.buscarLivros(query);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _solicitarEmprestimo(Livro livro) async {
    final usuarioId = getIt<AuthService>().getUsuarioIdAutenticado();
    if (usuarioId == null) return;

    try {
      await getIt<RegistrarEmprestimoUseCase>().execute(usuarioId, livro.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Empréstimo de "${livro.titulo}" realizado!')),
        );
        _carregarLivros(_searchController.text);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Livros')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título, autor ou categoria...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _carregarLivros();
                  },
                ),
              ),
              onChanged: _carregarLivros,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _livros.length,
                    itemBuilder: (context, index) {
                      final livro = _livros[index];
                      return ListTile(
                        title: Text(livro.titulo),
                        subtitle: Text('${livro.autor} - ${livro.categoria}'),
                        trailing: ElevatedButton(
                          onPressed: livro.status == 'DISPONIVEL' 
                            ? () => _solicitarEmprestimo(livro) 
                            : null,
                          child: Text(livro.status == 'DISPONIVEL' ? 'PEGAR' : 'INDISP.'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
