import '../../domain/entities/livro.dart';
import '../../domain/repositories/livro_repository.dart';
import '../models/livro_model.dart';
import '../../core/services/CacheService.dart';
import 'base_repository.dart';

class LivroRepositoryImpl extends BaseRepository implements LivroRepository {
  final CacheService _cacheService;
  static const String _cacheKey = 'catalogo_livros';

  LivroRepositoryImpl(super.databaseService, this._cacheService);

  @override
  Future<List<Livro>> getAllLivros() async {
    if (_cacheService.contains(_cacheKey)) {
      return _cacheService.get<List<Livro>>(_cacheKey)!;
    }

    final maps = await query('Livros', where: "status != 'INATIVO'");
    final result = maps.map((e) => LivroModel.fromMap(e)).toList();
    
    _cacheService.save(_cacheKey, result);
    return result;
  }

  @override
  Future<Livro?> getLivroById(int id) async {
    final maps = await query('Livros', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return LivroModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> cadastrarLivro(Livro livro) async {
    final model = LivroModel.fromEntity(livro);
    final id = await insert('Livros', model.toMap());
    _cacheService.remove(_cacheKey); // Invalida cache
    return id;
  }

  @override
  Future<void> atualizarLivro(Livro livro) async {
    final model = LivroModel.fromEntity(livro);
    await update('Livros', model.toMap(), 'id = ?', [livro.id]);
    _cacheService.remove(_cacheKey);
  }

  @override
  Future<void> inativarLivro(int id) async {
    await update('Livros', {'status': 'INATIVO'}, 'id = ?', [id]);
    _cacheService.remove(_cacheKey);
  }

  @override
  Future<List<Livro>> buscarLivros(String queryStr) async {
    final maps = await query(
      'Livros',
      where: "(titulo LIKE ? OR autor LIKE ? OR categoria LIKE ?) AND status != 'INATIVO'",
      whereArgs: ['%$queryStr%', '%$queryStr%', '%$queryStr%'],
    );
    return maps.map((e) => LivroModel.fromMap(e)).toList();
  }
}
