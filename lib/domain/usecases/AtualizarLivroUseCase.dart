import '../entities/livro.dart';
import '../repositories/livro_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class AtualizarLivroUseCase {
  final LivroRepository _repository;
  final AuthService _authService;

  AtualizarLivroUseCase(this._repository, this._authService);

  Future<void> execute(Livro livro) async {
    final usuarioLogado = _authService.usuarioLogado;

    // T-UNIT-BOK-003
    if (usuarioLogado?.perfil != AppConstants.profileAdmin &&
        usuarioLogado?.perfil != AppConstants.profileAdminInicial &&
        usuarioLogado?.perfil != AppConstants.profileEditor) {
      throw UnauthorizedException('Sem permissão para atualizar livros.');
    }

    final existente = await _repository.getLivroById(livro.id!);
    if (existente == null) {
      throw ValidationException('Livro não encontrado.');
    }

    await _repository.atualizarLivro(livro);
  }
}
