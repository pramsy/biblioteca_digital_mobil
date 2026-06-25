import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../constants/app_constants.dart';

class SeedService {
  final UsuarioRepository _usuarioRepository;

  SeedService(this._usuarioRepository);

  Future<void> inicializar() async {
    final existeAdmin = await _usuarioRepository.existeAdmin();
    if (!existeAdmin) {
      const admin = Usuario(
        nome: 'Administrador Inicial',
        email: 'admin@biblioteca.com',
        senha: 'admin123', // Em prod usar hash
        perfil: AppConstants.profileAdminInicial,
        primeiroAcesso: true,
      );
      await _usuarioRepository.cadastrarUsuario(admin);
    }
  }
}
