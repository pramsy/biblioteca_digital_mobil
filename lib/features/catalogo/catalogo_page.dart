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
          SnackBar(
            content: Text('Ação necessária: Erro ao carregar livros ($e)'),
            backgroundColor: Colors.red[800],
          ),
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
          SnackBar(
            content: Text('Sucesso: Empréstimo de "${livro.titulo}" realizado.'),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
        _carregarLivros(_searchController.text);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
      }
    }
  }

  Future<void> _deletarLivro(Livro livro) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Livro'),
        content: Text('Deseja realmente remover "${livro.titulo}" do catálogo? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('MANTER')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[50], foregroundColor: Colors.red),
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await getIt<InativarLivroUseCase>().execute(livro.id!);
        _carregarLivros(_searchController.text);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red[800]),
          );
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
            Semantics(
              label: 'Adicionar novo livro ao acervo',
              child: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () async {
                  final result = await Navigator.pushNamed(context, AppRoutes.livroForm);
                  if (result == true) _carregarLivros();
                },
              ),
            )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Semantics(
              label: 'Campo de busca no catálogo',
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Título, autor ou categoria...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          _carregarLivros();
                        },
                      )
                    : null,
                ),
                onChanged: (value) => _carregarLivros(value),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Buscando exemplares...'),
                      ],
                    ),
                  )
                : _livros.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.library_books_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            const Text('Nenhum exemplar encontrado no acervo.', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: _livros.length,
                        itemBuilder: (context, index) {
                          final livro = _livros[index];
                          final disponivel = livro.status == AppConstants.bookStatusDisponivel;

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(livro.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Autor: ${livro.autor}'),
                                  Text('Categoria: ${livro.categoria}'),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: disponivel ? Colors.green[50] : Colors.orange[50],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      livro.status,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: disponivel ? Colors.green[800] : Colors.orange[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: isAdmin
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Semantics(
                                          label: 'Editar dados de ${livro.titulo}',
                                          child: IconButton(
                                            icon: const Icon(Icons.edit_note, color: Colors.blue),
                                            onPressed: () async {
                                              final result = await Navigator.pushNamed(
                                                context,
                                                AppRoutes.livroForm,
                                                arguments: livro,
                                              );
                                              if (result == true) _carregarLivros();
                                            },
                                          ),
                                        ),
                                        Semantics(
                                          label: 'Remover ${livro.titulo} do acervo',
                                          child: IconButton(
                                            icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                                            onPressed: () => _deletarLivro(livro),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: disponivel ? () => _solicitarEmprestimo(livro) : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: disponivel ? null : Colors.grey[200],
                                        ),
                                        child: Text(disponivel ? 'PEGAR' : 'INDISP.'),
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
