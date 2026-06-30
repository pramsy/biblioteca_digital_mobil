import '../repositories/emprestimo_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class RegistrarDevolucaoUseCase {
  final EmprestimoRepository _repository;
  final AuthService _authService;

  RegistrarDevolucaoUseCase(this._repository, this._authService);

  Future<void> execute(int emprestimoId) async {
    final executor = _authService.usuarioLogado;
    if (executor == null) throw UnauthorizedException('Usuário não autenticado.');

    final emprestimo = await _repository.getEmprestimoById(emprestimoId);
    if (emprestimo == null) {
      throw ValidationException('Empréstimo não encontrado.');
    }

    // V02: IDOR Protection
    // Verifica se o empréstimo pertence ao usuário logado 
    // ou se o executor é um Administrador/Bibliotecário
    bool isOwner = emprestimo.usuarioId == executor.id;
    bool isStaff = executor.perfil != AppConstants.profileLeitor;

    if (!isOwner && !isStaff) {
      throw UnauthorizedException('Sem permissão para devolver este exemplar.');
    }

    if (emprestimo.status == 'DEVOLVIDO') {
      throw ValidationException('Livro já foi devolvido.');
    }

    await _repository.registrarDevolucao(emprestimoId, DateTime.now());
  }
}
