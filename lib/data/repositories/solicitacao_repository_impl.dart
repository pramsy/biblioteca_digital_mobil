import '../../domain/entities/solicitacao.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../models/solicitacao_model.dart';
import 'base_repository.dart';

class SolicitacaoRepositoryImpl extends BaseRepository implements SolicitacaoRepository {
  SolicitacaoRepositoryImpl(super.databaseService);

  @override
  Future<int> enviarSolicitacao(Solicitacao solicitacao) async {
    final model = SolicitacaoModel(
      usuarioId: solicitacao.usuarioId,
      assunto: solicitacao.assunto,
      descricao: solicitacao.descricao,
      prioridade: solicitacao.prioridade,
      dataCriacao: solicitacao.dataCriacao,
    );
    return await insert('Solicitacoes', model.toMap());
  }

  @override
  Future<void> responderSolicitacao(int id, String resposta, String status, int respondidoPorId) async {
    await update(
      'Solicitacoes',
      {
        'resposta': resposta,
        'status': status,
        'dataResposta': DateTime.now().toIso8601String(),
        'respondidoPorId': respondidoPorId,
      },
      'id = ?',
      [id],
    );
  }

  @override
  Future<List<Solicitacao>> getSolicitacoesByUsuario(int usuarioId) async {
    final maps = await query('Solicitacoes', where: 'usuarioId = ?', whereArgs: [usuarioId]);
    return maps.map((e) => SolicitacaoModel.fromMap(e)).toList();
  }

  @override
  Future<List<Solicitacao>> getAllSolicitacoes() async {
    final maps = await query('Solicitacoes');
    return maps.map((e) => SolicitacaoModel.fromMap(e)).toList();
  }

  @override
  Future<Solicitacao?> getSolicitacaoById(int id) async {
    final maps = await query('Solicitacoes', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SolicitacaoModel.fromMap(maps.first);
    }
    return null;
  }
}
