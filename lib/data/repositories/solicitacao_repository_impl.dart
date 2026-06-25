import '../../domain/entities/solicitacao.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../models/solicitacao_model.dart';
import '../../core/services/DatabaseService.dart';

class SolicitacaoRepositoryImpl implements SolicitacaoRepository {
  final DatabaseService _databaseService;

  SolicitacaoRepositoryImpl(this._databaseService);

  @override
  Future<int> enviarSolicitacao(Solicitacao solicitacao) async {
    final db = await _databaseService.database;
    final model = SolicitacaoModel(
      usuarioId: solicitacao.usuarioId,
      assunto: solicitacao.assunto,
      descricao: solicitacao.descricao,
      prioridade: solicitacao.prioridade,
      dataCriacao: solicitacao.dataCriacao,
    );
    return await db.insert('Solicitacoes', model.toMap());
  }

  @override
  Future<void> responderSolicitacao(int id, String resposta, String status, int respondidoPorId) async {
    final db = await _databaseService.database;
    await db.update(
      'Solicitacoes',
      {
        'resposta': resposta,
        'status': status,
        'dataResposta': DateTime.now().toIso8601String(),
        'respondidoPorId': respondidoPorId,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Solicitacao>> getSolicitacoesByUsuario(int usuarioId) async {
    final db = await _databaseService.database;
    final maps = await db.query('Solicitacoes', where: 'usuarioId = ?', whereArgs: [usuarioId]);
    return maps.map((e) => SolicitacaoModel.fromMap(e)).toList();
  }

  @override
  Future<List<Solicitacao>> getAllSolicitacoes() async {
    final db = await _databaseService.database;
    final maps = await db.query('Solicitacoes');
    return maps.map((e) => SolicitacaoModel.fromMap(e)).toList();
  }

  @override
  Future<Solicitacao?> getSolicitacaoById(int id) async {
    final db = await _databaseService.database;
    final maps = await db.query('Solicitacoes', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SolicitacaoModel.fromMap(maps.first);
    }
    return null;
  }
}
