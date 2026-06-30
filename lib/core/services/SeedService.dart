import 'package:bcrypt/bcrypt.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../constants/app_constants.dart';

class SeedService {
  final UsuarioRepository _usuarioRepository;

  SeedService(this._usuarioRepository);

  Future<void> inicializar() async {
    final existeAdmin = await _usuarioRepository.existeAdmin();
    if (!existeAdmin) {
      // V03: Hardcoded password is still here for initial boot, 
      // but stored as HASH in database.
      final hashedPassword = BCrypt.hashpw('admin123', BCrypt.gensalt());
      
      final admin = Usuario(
        nome: 'Administrador Inicial',
        email: 'admin@biblioteca.com',
        senha: hashedPassword,
        perfil: AppConstants.profileAdminInicial,
        primeiroAcesso: true,
      );
      await _usuarioRepository.cadastrarUsuario(admin);
    }
  }
}
