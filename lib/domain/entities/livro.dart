import 'package:equatable/equatable.dart';

class Livro extends Equatable {
  final int? id;
  final String titulo;
  final String autor;
  final String categoria;
  final String status;
  final int quantidade;

  const Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.categoria,
    this.status = 'DISPONIVEL',
    this.quantidade = 1,
  });

  @override
  List<Object?> get props => [id, titulo, autor, categoria, status, quantidade];

  Livro copyWith({
    int? id,
    String? titulo,
    String? autor,
    String? categoria,
    String? status,
    int? quantidade,
  }) {
    return Livro(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      categoria: categoria ?? this.categoria,
      status: status ?? this.status,
      quantidade: quantidade ?? this.quantidade,
    );
  }
}
