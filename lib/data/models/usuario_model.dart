import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    super.id,
    required super.nome,
    required super.email,
    required super.senha,
    required super.perfil,
    super.status,
    super.primeiroAcesso,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      perfil: map['perfil'],
      status: map['status'],
      primeiroAcesso: map['primeiroAcesso'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'perfil': perfil,
      'status': status,
      'primeiroAcesso': primeiroAcesso ? 1 : 0,
    };
  }

  factory UsuarioModel.fromEntity(Usuario usuario) {
    return UsuarioModel(
      id: usuario.id,
      nome: usuario.nome,
      email: usuario.email,
      senha: usuario.senha,
      perfil: usuario.perfil,
      status: usuario.status,
      primeiroAcesso: usuario.primeiroAcesso,
    );
  }
}
