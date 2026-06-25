import '../../domain/entities/emprestimo.dart';
import '../../domain/repositories/emprestimo_repository.dart';
import '../models/emprestimo_model.dart';
import '../../core/services/DatabaseService.dart';

class EmprestimoRepositoryImpl implements EmprestimoRepository {
  final DatabaseService _databaseService;

  EmprestimoRepositoryImpl(this._databaseService);

  @override
  Future<int> registrarEmprestimo(Emprestimo emprestimo) async {
    final db = await _databaseService.database;
    final model = EmprestimoModel(
      usuarioId: emprestimo.usuarioId,
      livroId: emprestimo.livroId,
      dataEmprestimo: emprestimo.dataEmprestimo,
      dataPrevisaoDevolucao: emprestimo.dataPrevisaoDevolucao,
    );
    
    return await db.transaction((txn) async {
      final id = await txn.insert('Emprestimos', model.toMap());
      await txn.update(
        'Livros',
        {'status': 'EMPRESTADO'},
        where: 'id = ?',
        whereArgs: [emprestimo.livroId],
      );
      return id;
    });
  }

  @override
  Future<void> registrarDevolucao(int id, DateTime dataDevolucao) async {
    final db = await _databaseService.database;
    final emprestimo = await getEmprestimoById(id);
    if (emprestimo == null) return;

    await db.transaction((txn) async {
      await txn.update(
        'Emprestimos',
        {
          'dataDevolucao': dataDevolucao.toIso8601String(),
          'status': 'DEVOLVIDO',
        },
        where: 'id = ?',
        whereArgs: [id],
      );
      await txn.update(
        'Livros',
        {'status': 'DISPONIVEL'},
        where: 'id = ?',
        whereArgs: [emprestimo.livroId],
      );
    });
  }

  @override
  Future<void> renovarEmprestimo(int id, DateTime novaDataPrevisao) async {
    final db = await _databaseService.database;
    await db.update(
      'Emprestimos',
      {'dataPrevisaoDevolucao': novaDataPrevisao.toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Emprestimo>> getEmprestimosByUsuario(int usuarioId) async {
    final db = await _databaseService.database;
    final maps = await db.query('Emprestimos', where: 'usuarioId = ?', whereArgs: [usuarioId]);
    return maps.map((e) => EmprestimoModel.fromMap(e)).toList();
  }

  @override
  Future<List<Emprestimo>> getAllEmprestimos() async {
    final db = await _databaseService.database;
    final maps = await db.query('Emprestimos');
    return maps.map((e) => EmprestimoModel.fromMap(e)).toList();
  }

  @override
  Future<Emprestimo?> getEmprestimoById(int id) async {
    final db = await _databaseService.database;
    final maps = await db.query('Emprestimos', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return EmprestimoModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> getRelatorioDados(DateTime inicio, DateTime fim) async {
    final db = await _databaseService.database;
    // Simplified report query
    return await db.rawQuery('''
      SELECT COUNT(*) as totalEmprestimos
      FROM Emprestimos
      WHERE dataEmprestimo BETWEEN ? AND ?
    ''', [inicio.toIso8601String(), fim.toIso8601String()]);
  }
}
