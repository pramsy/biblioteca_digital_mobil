import '../repositories/solicitacao_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class ResponderSolicitacaoUseCase {
  final SolicitacaoRepository _repository;
  final AuthService _authService;

  ResponderSolicitacaoUseCase(this._repository, this._authService);

  Future<void> execute(int id, String resposta) async {
    final usuarioLogado = _authService.usuarioLogado;

    // T-UNIT-REQ-004: Sem Permissão
    if (usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial &&
        usuarioLogado?.perfil != AppConstants.profileEditor) {
      throw UnauthorizedException('Sem permissão para responder solicitações.');
    }

    // T-UNIT-REQ-003: Responder Válida
    final solicitacao = await _repository.getSolicitacaoById(id);
    if (solicitacao == null) {
      throw ValidationException('Solicitação não encontrada.');
    }

    await _repository.responderSolicitacao(
      id,
      resposta,
      AppConstants.statusRespondida,
      usuarioLogado!.id!,
    );
  }
}
