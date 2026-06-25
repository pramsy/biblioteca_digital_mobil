import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String perfil;
  final String status;
  final bool primeiroAcesso;

  const Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.perfil,
    this.status = 'ATIVO',
    this.primeiroAcesso = false,
  });

  @override
  List<Object?> get props => [id, nome, email, senha, perfil, status, primeiroAcesso];

  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? senha,
    String? perfil,
    String? status,
    bool? primeiroAcesso,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      perfil: perfil ?? this.perfil,
      status: status ?? this.status,
      primeiroAcesso: primeiroAcesso ?? this.primeiroAcesso,
    );
  }
}
