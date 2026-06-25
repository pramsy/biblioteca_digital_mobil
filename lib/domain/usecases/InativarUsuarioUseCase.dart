import '../repositories/usuario_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class InativarUsuarioUseCase {
  final UsuarioRepository _repository;
  final AuthService _authService;

  InativarUsuarioUseCase(this._repository, this._authService);

  Future<void> execute(int id) async {
    final usuarioLogado = _authService.usuarioLogado;

    // T-UNIT-USR-005: Somente ADMIN
    if (usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial) {
      throw UnauthorizedException('Apenas administradores podem inativar usuários.');
    }

    await _repository.inativarUsuario(id);
  }
}
