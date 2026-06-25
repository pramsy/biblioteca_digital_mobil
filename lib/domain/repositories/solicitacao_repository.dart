import '../entities/solicitacao.dart';

abstract class SolicitacaoRepository {
  Future<int> enviarSolicitacao(Solicitacao solicitacao);
  Future<void> responderSolicitacao(int id, String resposta, String status, int respondidoPorId);
  Future<List<Solicitacao>> getSolicitacoesByUsuario(int usuarioId);
  Future<List<Solicitacao>> getAllSolicitacoes();
  Future<Solicitacao?> getSolicitacaoById(int id);
}
