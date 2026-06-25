import '../../domain/entities/livro.dart';
import '../../domain/repositories/livro_repository.dart';
import '../models/livro_model.dart';
import '../../core/services/DatabaseService.dart';

class LivroRepositoryImpl implements LivroRepository {
  final DatabaseService _databaseService;

  LivroRepositoryImpl(this._databaseService);

  @override
  Future<List<Livro>> getAllLivros() async {
    final db = await _databaseService.database;
    final maps = await db.query('Livros', where: "status != 'INATIVO'");
    return maps.map((e) => LivroModel.fromMap(e)).toList();
  }

  @override
  Future<Livro?> getLivroById(int id) async {
    final db = await _databaseService.database;
    final maps = await db.query('Livros', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return LivroModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> cadastrarLivro(Livro livro) async {
    final db = await _databaseService.database;
    final model = LivroModel.fromEntity(livro);
    return await db.insert('Livros', model.toMap());
  }

  @override
  Future<void> atualizarLivro(Livro livro) async {
    final db = await _databaseService.database;
    final model = LivroModel.fromEntity(livro);
    await db.update('Livros', model.toMap(), where: 'id = ?', whereArgs: [livro.id]);
  }

  @override
  Future<void> inativarLivro(int id) async {
    final db = await _databaseService.database;
    await db.update('Livros', {'status': 'INATIVO'}, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Livro>> buscarLivros(String query) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'Livros',
      where: "(titulo LIKE ? OR autor LIKE ? OR categoria LIKE ?) AND status != 'INATIVO'",
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return maps.map((e) => LivroModel.fromMap(e)).toList();
  }
}
