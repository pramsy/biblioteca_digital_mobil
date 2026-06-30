import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../errors/exceptions.dart';
import 'CacheService.dart';

class AuthService {
  final UsuarioRepository _usuarioRepository;
  final CacheService _cacheService;
  
  static const String _sessionKey = 'usuario_logado';
  int _loginAttempts = 0;
  DateTime? _lastAttemptTime;

  AuthService(this._usuarioRepository, this._cacheService);

  Usuario? get usuarioLogado => _cacheService.get<Usuario>(_sessionKey);

  Future<Usuario> login(String email, String senha) async {
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

    _cacheService.save(_sessionKey, usuario);
    _loginAttempts = 0;
    return usuario;
  }

  void logout() {
    _cacheService.remove(_sessionKey);
  }

  int? getUsuarioIdAutenticado() {
    return usuarioLogado?.id;
  }
}
