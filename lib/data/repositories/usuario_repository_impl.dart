import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../models/usuario_model.dart';
import '../../core/services/DatabaseService.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final DatabaseService _databaseService;

  UsuarioRepositoryImpl(this._databaseService);

  @override
  Future<Usuario?> getUsuarioByEmail(String email) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'Usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UsuarioModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<Usuario?> getUsuarioById(int id) async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'Usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UsuarioModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<int> cadastrarUsuario(Usuario usuario) async {
    final db = await _databaseService.database;
    final model = UsuarioModel.fromEntity(usuario);
    return await db.insert('Usuarios', model.toMap());
  }

  @override
  Future<void> atualizarUsuario(Usuario usuario) async {
    final db = await _databaseService.database;
    final model = UsuarioModel.fromEntity(usuario);
    await db.update(
      'Usuarios',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  @override
  Future<void> inativarUsuario(int id) async {
    final db = await _databaseService.database;
    await db.update(
      'Usuarios',
      {'status': 'INATIVO'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Usuario>> getAllUsuarios() async {
    final db = await _databaseService.database;
    final maps = await db.query('Usuarios', where: "status != 'INATIVO'");
    return maps.map((e) => UsuarioModel.fromMap(e)).toList();
  }

  @override
  Future<bool> existeAdmin() async {
    final db = await _databaseService.database;
    final maps = await db.query(
      'Usuarios',
      where: "perfil IN ('ADMIN', 'ADMIN_INICIAL') AND status = 'ATIVO'",
    );
    return maps.isNotEmpty;
  }
}
