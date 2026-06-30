import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../models/usuario_model.dart';
import 'base_repository.dart';

class UsuarioRepositoryImpl extends BaseRepository implements UsuarioRepository {
  UsuarioRepositoryImpl(super.databaseService);

  @override
  Future<Usuario?> getUsuarioByEmail(String email) async {
    final maps = await query('Usuarios', where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return UsuarioModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<Usuario?> getUsuarioById(int id) async {
    final maps = await query('Usuarios', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UsuarioModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> cadastrarUsuario(Usuario usuario) async {
    final model = UsuarioModel.fromEntity(usuario);
    return await insert('Usuarios', model.toMap());
  }

  @override
  Future<void> atualizarUsuario(Usuario usuario) async {
    final model = UsuarioModel.fromEntity(usuario);
    await update('Usuarios', model.toMap(), 'id = ?', [usuario.id]);
  }

  @override
  Future<void> inativarUsuario(int id) async {
    await update('Usuarios', {'status': 'INATIVO'}, 'id = ?', [id]);
  }

  @override
  Future<List<Usuario>> getAllUsuarios() async {
    final maps = await query('Usuarios', where: "status != 'INATIVO'");
    return maps.map((e) => UsuarioModel.fromMap(e)).toList();
  }

  @override
  Future<bool> existeAdmin() async {
    final maps = await query(
      'Usuarios',
      where: "perfil IN ('ADMIN', 'ADMIN_INICIAL') AND status = 'ATIVO'",
    );
    return maps.isNotEmpty;
  }
}
