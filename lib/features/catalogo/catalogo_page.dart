import 'package:flutter/material.dart';
import '../../app/config/injection.dart';
import '../../domain/entities/livro.dart';
import '../../domain/repositories/livro_repository.dart';
import '../../domain/usecases/RegistrarEmprestimoUseCase.dart';
import '../../domain/usecases/InativarLivroUseCase.dart';
import '../../core/services/AuthService.dart';
import '../../core/constants/app_constants.dart';
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
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final repository = getIt<LivroRepository>();
      List<Livro> resultado;
      if (query.isEmpty) {
        resultado = await repository.getAllLivros();
      } else {
        resultado = await repository.buscarLivros(query);
      }
      
      if (mounted) {
        setState(() {
          _livros = resultado;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar livros: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

  Future<void> _deletarLivro(Livro livro) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Livro'),
        content: Text('Deseja realmente excluir "${livro.titulo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('EXCLUIR', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await getIt<InativarLivroUseCase>().execute(livro.id!);
        _carregarLivros(_searchController.text);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = getIt<AuthService>().usuarioLogado;
    final isAdmin = usuario?.perfil == AppConstants.profileAdmin || 
                    usuario?.perfil == AppConstants.profileAdminInicial ||
                    usuario?.perfil == AppConstants.profileBibliotecario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Livros'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.pushNamed(context, AppRoutes.livroForm);
                if (result == true) _carregarLivros();
              },
            )
        ],
      ),
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
              onChanged: (value) => _carregarLivros(value),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _livros.isEmpty
                    ? const Center(child: Text('Nenhum livro encontrado.'))
                    : ListView.builder(
                        itemCount: _livros.length,
                        itemBuilder: (context, index) {
                          final livro = _livros[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text(livro.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('${livro.autor} - ${livro.categoria}\nStatus: ${livro.status}'),
                              isThreeLine: true,
                              trailing: isAdmin
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () async {
                                            final result = await Navigator.pushNamed(
                                              context,
                                              AppRoutes.livroForm,
                                              arguments: livro,
                                            );
                                            if (result == true) _carregarLivros();
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _deletarLivro(livro),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                        onPressed: livro.status == AppConstants.bookStatusDisponivel
                                            ? () => _solicitarEmprestimo(livro)
                                            : null,
                                        child: Text(livro.status == AppConstants.bookStatusDisponivel ? 'PEGAR' : 'INDISP.'),
                                      ),
                                    ),
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
