import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../errors/exceptions.dart';

class AuthService {
  final UsuarioRepository _usuarioRepository;
  Usuario? _usuarioLogado;
  int _loginAttempts = 0;
  DateTime? _lastAttemptTime;

  AuthService(this._usuarioRepository);

  Usuario? get usuarioLogado => _usuarioLogado;

  Future<Usuario> login(String email, String senha) async {
    // T-UNIT-AUTH-003: Rate Limiting
    if (_loginAttempts >= 5 && _lastAttemptTime != null) {
      if (DateTime.now().difference(_lastAttemptTime!).inMinutes < 1) {
        throw RateLimitException('Muitas tentativas. Tente novamente em 1 minuto.');
      } else {
        _loginAttempts = 0;
      }
    }

    final usuario = await _usuarioRepository.getUsuarioByEmail(email);

    if (usuario == null || usuario.senha != senha) {
      _loginAttempts++;
      _lastAttemptTime = DateTime.now();
      throw AuthException('Credenciais inválidas');
    }

    if (usuario.status == 'INATIVO') {
      throw AuthException('Usuário inativo');
    }

    _usuarioLogado = usuario;
    _loginAttempts = 0;
    return usuario;
  }

  void logout() {
    _usuarioLogado = null;
  }

  int? getUsuarioIdAutenticado() {
    return _usuarioLogado?.id;
  }
}
