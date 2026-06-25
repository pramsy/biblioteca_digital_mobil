import '../repositories/emprestimo_repository.dart';
import '../../core/errors/exceptions.dart';

class RegistrarDevolucaoUseCase {
  final EmprestimoRepository _repository;

  RegistrarDevolucaoUseCase(this._repository);

  Future<void> execute(int emprestimoId) async {
    // T-UNIT-LON-003: Registrar Devolução
    final emprestimo = await _repository.getEmprestimoById(emprestimoId);
    if (emprestimo == null) {
      throw ValidationException('Empréstimo não encontrado.');
    }

    if (emprestimo.status == 'DEVOLVIDO') {
      throw ValidationException('Livro já foi devolvido.');
    }

    await _repository.registrarDevolucao(emprestimoId, DateTime.now());
  }
}
