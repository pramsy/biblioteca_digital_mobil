import '../entities/emprestimo.dart';

abstract class EmprestimoRepository {
  Future<int> registrarEmprestimo(Emprestimo emprestimo);
  Future<void> registrarDevolucao(int id, DateTime dataDevolucao);
  Future<void> renovarEmprestimo(int id, DateTime novaDataPrevisao);
  Future<List<Emprestimo>> getEmprestimosByUsuario(int usuarioId);
  Future<List<Emprestimo>> getAllEmprestimos();
  Future<Emprestimo?> getEmprestimoById(int id);
  Future<List<Map<String, dynamic>>> getRelatorioDados(DateTime inicio, DateTime fim);
}
