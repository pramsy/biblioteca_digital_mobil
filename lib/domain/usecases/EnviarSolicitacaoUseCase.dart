import '../entities/solicitacao.dart';
import '../repositories/solicitacao_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';

class EnviarSolicitacaoUseCase {
  final SolicitacaoRepository _repository;
  final AuthService _authService;

  EnviarSolicitacaoUseCase(this._repository, this._authService);

  Future<int> execute(String assunto, String descricao, String prioridade) async {
    final usuarioId = _authService.getUsuarioIdAutenticado();
    
    // T-UNIT-REQ-002: Falha por Autenticação
    if (usuarioId == null) {
      throw AuthenticationRequiredException('Usuário deve estar autenticado para enviar solicitações.');
    }

    // T-UNIT-REQ-001: Envio Válido
    final solicitacao = Solicitacao(
      usuarioId: usuarioId,
      assunto: assunto,
      descricao: descricao,
      prioridade: prioridade,
      dataCriacao: DateTime.now(),
    );

    return await _repository.enviarSolicitacao(solicitacao);
  }
}
