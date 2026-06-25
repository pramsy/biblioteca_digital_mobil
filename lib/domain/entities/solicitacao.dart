import 'package:equatable/equatable.dart';

class Solicitacao extends Equatable {
  final int? id;
  final int usuarioId;
  final String assunto;
  final String descricao;
  final String prioridade;
  final String status;
  final String? resposta;
  final DateTime dataCriacao;
  final DateTime? dataResposta;
  final int? respondidoPorId;

  const Solicitacao({
    this.id,
    required this.usuarioId,
    required this.assunto,
    required this.descricao,
    required this.prioridade,
    this.status = 'ABERTA',
    this.resposta,
    required this.dataCriacao,
    this.dataResposta,
    this.respondidoPorId,
  });

  @override
  List<Object?> get props => [
        id,
        usuarioId,
        assunto,
        descricao,
        prioridade,
        status,
        resposta,
        dataCriacao,
        dataResposta,
        respondidoPorId,
      ];
}
