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
    final executor = _authService.usuarioLogado;
    final alvo = await _repository.getUsuarioById(usuario.id!);

    if (alvo == null) throw ValidationException('Usuário não encontrado.');

    bool isSelf = executor?.id == usuario.id;
    bool isInitialAdmin = executor?.perfil == AppConstants.profileAdminInicial;
    bool isAdmin = executor?.perfil == AppConstants.profileAdmin;

    // Se não for ele mesmo e não for admin, bloqueia
    if (!isSelf && !isInitialAdmin && !isAdmin) {
      throw UnauthorizedException('Sem permissão para atualizar este usuário.');
    }

    // Se for Admin (não inicial), não pode editar Admin Inicial ou outros Admins
    if (isAdmin && !isInitialAdmin && !isSelf) {
      if (alvo.perfil == AppConstants.profileAdminInicial || alvo.perfil == AppConstants.profileAdmin) {
        throw UnauthorizedException('Administradores não podem editar outros Administradores.');
      }
    }

    await _repository.atualizarUsuario(usuario);
  }
}
