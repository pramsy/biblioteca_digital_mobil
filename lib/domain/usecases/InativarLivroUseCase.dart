import '../repositories/livro_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class InativarLivroUseCase {
  final LivroRepository _livroRepository;
  final AuthService _authService;

  InativarLivroUseCase(this._livroRepository, this._authService);

  Future<void> execute(int id) async {
    final usuarioLogado = _authService.usuarioLogado;

    if (usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial &&
        usuarioLogado?.perfil != AppConstants.profileBibliotecario) {
      throw UnauthorizedException('Sem permissão para inativar livros.');
    }

    final livro = await _livroRepository.getLivroById(id);
    if (livro == null) {
      throw ValidationException('Livro não encontrado.');
    }

    if (livro.status == AppConstants.bookStatusEmprestado) {
      throw BookLockedException('Não é possível inativar um livro emprestado.');
    }

    await _livroRepository.inativarLivro(id);
  }
}
