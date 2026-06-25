import '../entities/emprestimo.dart';
import '../repositories/emprestimo_repository.dart';
import '../repositories/livro_repository.dart';
import '../../core/errors/exceptions.dart';
import '../../core/constants/app_constants.dart';

class RegistrarEmprestimoUseCase {
  final EmprestimoRepository _emprestimoRepository;
  final LivroRepository _livroRepository;

  RegistrarEmprestimoUseCase(this._emprestimoRepository, this._livroRepository);

  Future<int> execute(int usuarioId, int livroId) async {
    final livro = await _livroRepository.getLivroById(livroId);
    
    // T-UNIT-LON-002: Impedido por Indisponibilidade
    if (livro == null || livro.status != AppConstants.bookStatusDisponivel) {
      throw BookUnavailableException('Livro não disponível para empréstimo.');
    }

    // T-UNIT-LON-001: Válido
    final emprestimo = Emprestimo(
      usuarioId: usuarioId,
      livroId: livroId,
      dataEmprestimo: DateTime.now(),
      dataPrevisaoDevolucao: DateTime.now().add(const Duration(days: 7)),
    );

    return await _emprestimoRepository.registrarEmprestimo(emprestimo);
  }
}
