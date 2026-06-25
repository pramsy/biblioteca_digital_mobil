import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class CadastrarEditorUseCase {
  final UsuarioRepository _repository;
  final AuthService _authService;

  CadastrarEditorUseCase(this._repository, this._authService);

  Future<int> execute(Usuario editor) async {
    final usuarioLogado = _authService.usuarioLogado;
    
    // T-UNIT-USR-001: Somente ADMIN
    if (usuarioLogado?.perfil != AppConstants.profileAdmin && 
        usuarioLogado?.perfil != AppConstants.profileAdminInicial) {
      throw UnauthorizedException('Apenas administradores podem cadastrar editores.');
    }

    final editorComPerfil = editor.copyWith(perfil: AppConstants.profileEditor);
    
    // Validações básicas (pode reutilizar lógica de CadastrarUsuario se quiser)
    final existente = await _repository.getUsuarioByEmail(editor.email);
    if (existente != null) {
      throw UserConflictException('E-mail já cadastrado.');
    }

    return await _repository.cadastrarUsuario(editorComPerfil);
  }
}
