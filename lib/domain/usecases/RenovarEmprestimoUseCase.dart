import '../repositories/emprestimo_repository.dart';
import '../../core/errors/exceptions.dart';

class RenovarEmprestimoUseCase {
  final EmprestimoRepository _repository;

  RenovarEmprestimoUseCase(this._repository);

  Future<void> execute(int emprestimoId) async {
    // T-UNIT-LON-004: Renovação Válida
    final emprestimo = await _repository.getEmprestimoById(emprestimoId);
    if (emprestimo == null) {
      throw ValidationException('Empréstimo não encontrado.');
    }

    if (emprestimo.status == 'DEVOLVIDO') {
      throw ValidationException('Não é possível renovar um empréstimo finalizado.');
    }

    final novaData = emprestimo.dataPrevisaoDevolucao.add(const Duration(days: 7));
    await _repository.renovarEmprestimo(emprestimoId, novaData);
  }
}
