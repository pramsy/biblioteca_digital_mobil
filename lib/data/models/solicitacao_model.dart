import '../../domain/entities/solicitacao.dart';

class SolicitacaoModel extends Solicitacao {
  const SolicitacaoModel({
    super.id,
    required super.usuarioId,
    required super.assunto,
    required super.descricao,
    required super.prioridade,
    super.status,
    super.resposta,
    required super.dataCriacao,
    super.dataResposta,
    super.respondidoPorId,
  });

  factory SolicitacaoModel.fromMap(Map<String, dynamic> map) {
    return SolicitacaoModel(
      id: map['id'],
      usuarioId: map['usuarioId'],
      assunto: map['assunto'],
      descricao: map['descricao'],
      prioridade: map['prioridade'],
      status: map['status'],
      resposta: map['resposta'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
      dataResposta: map['dataResposta'] != null ? DateTime.parse(map['dataResposta']) : null,
      respondidoPorId: map['respondidoPorId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'assunto': assunto,
      'descricao': descricao,
      'prioridade': prioridade,
      'status': status,
      'resposta': resposta,
      'dataCriacao': dataCriacao.toIso8601String(),
      'dataResposta': dataResposta?.toIso8601String(),
      'respondidoPorId': respondidoPorId,
    };
  }
}
