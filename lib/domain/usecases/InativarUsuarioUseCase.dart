import '../repositories/usuario_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class InativarUsuarioUseCase {
  final UsuarioRepository _repository;
  final AuthService _authService;

  InativarUsuarioUseCase(this._repository, this._authService);

  Future<void> execute(int id) async {
    final executor = _authService.usuarioLogado;
    final alvo = await _repository.getUsuarioById(id);

    if (alvo == null) throw ValidationException('Usuário não encontrado.');

    // Regras de Hierarquia
    if (executor?.perfil == AppConstants.profileAdminInicial) {
      // Admin Inicial pode inativar qualquer um, exceto ele mesmo (opcional)
      if (executor!.id == id) throw ValidationException('O Administrador Inicial não pode se inativar.');
    } else if (executor?.perfil == AppConstants.profileAdmin) {
      // Admin pode inativar Bibliotecários e Leitores
      if (alvo.perfil == AppConstants.profileAdmin || alvo.perfil == AppConstants.profileAdminInicial) {
        throw UnauthorizedException('Administradores não podem inativar outros Administradores.');
      }
    } else {
      throw UnauthorizedException('Sem permissão para inativar usuários.');
    }

    await _repository.inativarUsuario(id);
  }
}
