import 'package:bcrypt/bcrypt.dart';
import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class CadastrarUsuarioUseCase {
  final UsuarioRepository _repository;
  final AuthService _authService;

  CadastrarUsuarioUseCase(this._repository, this._authService);

  Future<int> execute(Usuario usuario) async {
    final executor = _authService.usuarioLogado;

    // Regras de Hierarquia
    if (usuario.perfil == AppConstants.profileAdmin) {
      if (executor?.perfil != AppConstants.profileAdminInicial) {
        throw UnauthorizedException('Apenas o Administrador Inicial pode cadastrar novos Administradores.');
      }
    } else if (usuario.perfil == AppConstants.profileBibliotecario) {
      if (executor?.perfil != AppConstants.profileAdminInicial && 
          executor?.perfil != AppConstants.profileAdmin) {
        throw UnauthorizedException('Sem permissão para cadastrar Bibliotecários.');
      }
    } else if (usuario.perfil == AppConstants.profileLeitor) {
      if (executor != null && 
          executor.perfil != AppConstants.profileAdminInicial && 
          executor.perfil != AppConstants.profileAdmin &&
          executor.perfil != AppConstants.profileBibliotecario) {
        throw UnauthorizedException('Sem permissão para cadastrar Leitores.');
      }
    }

    // Validação de Senha Forte
    if (usuario.senha.length < 8 ||
        !usuario.senha.contains(RegExp(r'[a-zA-Z]')) ||
        !usuario.senha.contains(RegExp(r'[0-9]'))) {
      throw WeakPasswordException('A senha deve ter no mínimo 8 caracteres, uma letra e um número.');
    }

    // E-mail duplicado
    final existente = await _repository.getUsuarioByEmail(usuario.email);
    if (existente != null) {
      throw UserConflictException('E-mail já cadastrado.');
    }

    // V01: Password Hashing (Salted BCrypt)
    final hashedPassword = BCrypt.hashpw(usuario.senha, BCrypt.gensalt());
    final usuarioComHash = usuario.copyWith(senha: hashedPassword);

    return await _repository.cadastrarUsuario(usuarioComHash);
  }
}
