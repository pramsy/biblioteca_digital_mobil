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

    if (usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial &&
        usuarioLogado?.perfil != AppConstants.profileBibliotecario) {
      throw UnauthorizedException('Sem permissão para cadastrar livros.');
    }

    if (livro.titulo.isEmpty || livro.autor.isEmpty || livro.categoria.isEmpty) {
      throw ValidationException('Título, autor e categoria são obrigatórios.');
    }

    // Garantir status DISPONIVEL ao cadastrar
    final livroParaSalvar = livro.copyWith(status: AppConstants.bookStatusDisponivel);

    return await _repository.cadastrarLivro(livroParaSalvar);
  }
}
