import '../entities/livro.dart';
import '../repositories/livro_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class CadastrarLivroUseCase {
  final LivroRepository _repository;
  final AuthService _authService;

  CadastrarLivroUseCase(this._repository, this._authService);

  Future<int> execute(Livro livro) async {
    final usuarioLogado = _authService.usuarioLogado;

    // T-UNIT-BOK-001: Editor ou Admin
    if (usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial &&
        usuarioLogado?.perfil != AppConstants.profileEditor) {
      throw UnauthorizedException('Sem permissão para cadastrar livros.');
    }

    // T-UNIT-BOK-002: Dados Inválidos
    if (livro.titulo.isEmpty || livro.autor.isEmpty || livro.categoria.isEmpty) {
      throw ValidationException('Título, autor e categoria são obrigatórios.');
    }

    return await _repository.cadastrarLivro(livro);
  }
}
