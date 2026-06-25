import '../entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario?> getUsuarioByEmail(String email);
  Future<Usuario?> getUsuarioById(int id);
  Future<int> cadastrarUsuario(Usuario usuario);
  Future<void> atualizarUsuario(Usuario usuario);
  Future<void> inativarUsuario(int id);
  Future<List<Usuario>> getAllUsuarios();
  Future<bool> existeAdmin();
}
