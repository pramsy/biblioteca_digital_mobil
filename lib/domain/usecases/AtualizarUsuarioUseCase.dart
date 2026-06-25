import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class AtualizarUsuarioUseCase {
  final UsuarioRepository _repository;
  final AuthService _authService;

  AtualizarUsuarioUseCase(this._repository, this._authService);

  Future<void> execute(Usuario usuario) async {
    final usuarioLogado = _authService.usuarioLogado;

    // T-UNIT-USR-004: Atualizar próprios dados ou ser ADMIN
    if (usuarioLogado?.id != usuario.id && 
        usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial) {
      throw UnauthorizedException('Sem permissão para atualizar este usuário.');
    }

    final existente = await _repository.getUsuarioById(usuario.id!);
    if (existente == null) {
      throw ValidationException('Usuário não encontrado.');
    }

    await _repository.atualizarUsuario(usuario);
  }
}
