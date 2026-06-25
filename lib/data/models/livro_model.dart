import '../../domain/entities/livro.dart';

class LivroModel extends Livro {
  const LivroModel({
    super.id,
    required super.titulo,
    required super.autor,
    required super.categoria,
    super.status,
    super.quantidade,
  });

  factory LivroModel.fromMap(Map<String, dynamic> map) {
    return LivroModel(
      id: map['id'],
      titulo: map['titulo'],
      autor: map['autor'],
      categoria: map['categoria'],
      status: map['status'],
      quantidade: map['quantidade'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'categoria': categoria,
      'status': status,
      'quantidade': quantidade,
    };
  }

  factory LivroModel.fromEntity(Livro livro) {
    return LivroModel(
      id: livro.id,
      titulo: livro.titulo,
      autor: livro.autor,
      categoria: livro.categoria,
      status: livro.status,
      quantidade: livro.quantidade,
    );
  }
}
