import 'package:equatable/equatable.dart';

class Emprestimo extends Equatable {
  final int? id;
  final int usuarioId;
  final int livroId;
  final DateTime dataEmprestimo;
  final DateTime dataPrevisaoDevolucao;
  final DateTime? dataDevolucao;
  final String status;

  const Emprestimo({
    this.id,
    required this.usuarioId,
    required this.livroId,
    required this.dataEmprestimo,
    required this.dataPrevisaoDevolucao,
    this.dataDevolucao,
    this.status = 'ATIVO',
  });

  @override
  List<Object?> get props => [
        id,
        usuarioId,
        livroId,
        dataEmprestimo,
        dataPrevisaoDevolucao,
        dataDevolucao,
        status,
      ];
}
