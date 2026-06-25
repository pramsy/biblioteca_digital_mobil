import '../entities/livro.dart';

abstract class LivroRepository {
  Future<List<Livro>> getAllLivros();
  Future<Livro?> getLivroById(int id);
  Future<int> cadastrarLivro(Livro livro);
  Future<void> atualizarLivro(Livro livro);
  Future<void> inativarLivro(int id);
  Future<List<Livro>> buscarLivros(String query);
}
