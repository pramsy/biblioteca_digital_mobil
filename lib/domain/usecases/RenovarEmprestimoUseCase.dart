import '../repositories/emprestimo_repository.dart';
import '../../core/services/AuthService.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class RenovarEmprestimoUseCase {
  final EmprestimoRepository _repository;
  final AuthService _authService;

  RenovarEmprestimoUseCase(this._repository, this._authService);

  Future<void> execute(int emprestimoId) async {
    final executor = _authService.usuarioLogado;
    if (executor == null) throw UnauthorizedException('Usuário não autenticado.');

    final emprestimo = await _repository.getEmprestimoById(emprestimoId);
    if (emprestimo == null) {
      throw ValidationException('Empréstimo não encontrado.');
    }

    // V02: IDOR Protection
    bool isOwner = emprestimo.usuarioId == executor.id;
    bool isStaff = executor.perfil != AppConstants.profileLeitor;

    if (!isOwner && !isStaff) {
      throw UnauthorizedException('Sem permissão para renovar este empréstimo.');
    }

    if (emprestimo.status == 'DEVOLVIDO') {
      throw ValidationException('Não é possível renovar um empréstimo finalizado.');
    }

    final novaData = emprestimo.dataPrevisaoDevolucao.add(const Duration(days: 7));
    await _repository.renovarEmprestimo(emprestimoId, novaData);
  }
}
