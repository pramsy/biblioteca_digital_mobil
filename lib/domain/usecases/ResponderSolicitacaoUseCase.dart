import '../repositories/solicitacao_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/services/JobQueueService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class ResponderSolicitacaoUseCase {
  final SolicitacaoRepository _repository;
  final AuthService _authService;
  final JobQueueService _jobQueue;

  ResponderSolicitacaoUseCase(this._repository, this._authService, this._jobQueue);

  Future<void> execute(int id, String resposta) async {
    final usuarioLogado = _authService.usuarioLogado;

    if (usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial &&
        usuarioLogado?.perfil != AppConstants.profileBibliotecario) {
      throw UnauthorizedException('Sem permissão para responder solicitações.');
    }

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

    // Job assíncrono para "Notificar Usuário" sem travar a UI
    _jobQueue.addJob(() async {
      print('Simulando envio de notificação para usuário ${solicitacao.usuarioId}...');
      await Future.delayed(const Duration(seconds: 2));
      print('Notificação enviada.');
    });
  }
}
