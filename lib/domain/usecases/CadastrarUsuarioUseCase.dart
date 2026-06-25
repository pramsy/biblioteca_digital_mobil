import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';
import '../../core/errors/exceptions.dart';

class CadastrarUsuarioUseCase {
  final UsuarioRepository _repository;

  CadastrarUsuarioUseCase(this._repository);

  Future<int> execute(Usuario usuario) async {
    // T-UNIT-USR-002: Senha forte
    if (usuario.senha.length < 8 ||
        !usuario.senha.contains(RegExp(r'[a-zA-Z]')) ||
        !usuario.senha.contains(RegExp(r'[0-9]'))) {
      throw WeakPasswordException('A senha deve ter no mínimo 8 caracteres, uma letra e um número.');
    }

    // T-UNIT-USR-003: E-mail duplicado
    final existente = await _repository.getUsuarioByEmail(usuario.email);
    if (existente != null) {
      throw UserConflictException('E-mail já cadastrado.');
    }

    return await _repository.cadastrarUsuario(usuario);
  }
}
