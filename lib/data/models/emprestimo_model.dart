import '../../domain/entities/emprestimo.dart';

class EmprestimoModel extends Emprestimo {
  const EmprestimoModel({
    super.id,
    required super.usuarioId,
    required super.livroId,
    required super.dataEmprestimo,
    required super.dataPrevisaoDevolucao,
    super.dataDevolucao,
    super.status,
  });

  factory EmprestimoModel.fromMap(Map<String, dynamic> map) {
    return EmprestimoModel(
      id: map['id'],
      usuarioId: map['usuarioId'],
      livroId: map['livroId'],
      dataEmprestimo: DateTime.parse(map['dataEmprestimo']),
      dataPrevisaoDevolucao: DateTime.parse(map['dataPrevisaoDevolucao']),
      dataDevolucao: map['dataDevolucao'] != null ? DateTime.parse(map['dataDevolucao']) : null,
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'livroId': livroId,
      'dataEmprestimo': dataEmprestimo.toIso8601String(),
      'dataPrevisaoDevolucao': dataPrevisaoDevolucao.toIso8601String(),
      'dataDevolucao': dataDevolucao?.toIso8601String(),
      'status': status,
    };
  }
}
