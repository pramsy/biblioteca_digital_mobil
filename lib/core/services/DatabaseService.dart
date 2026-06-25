import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('biblioteca.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        perfil TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'ATIVO',
        primeiroAcesso INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE Livros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        autor TEXT NOT NULL,
        categoria TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'DISPONIVEL',
        quantidade INTEGER DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE Solicitacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER NOT NULL,
        assunto TEXT NOT NULL,
        descricao TEXT NOT NULL,
        prioridade TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'ABERTA',
        resposta TEXT,
        dataCriacao TEXT NOT NULL,
        dataResposta TEXT,
        respondidoPorId INTEGER,
        FOREIGN KEY (usuarioId) REFERENCES Usuarios (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Emprestimos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER NOT NULL,
        livroId INTEGER NOT NULL,
        dataEmprestimo TEXT NOT NULL,
        dataPrevisaoDevolucao TEXT NOT NULL,
        dataDevolucao TEXT,
        status TEXT NOT NULL DEFAULT 'ATIVO',
        FOREIGN KEY (usuarioId) REFERENCES Usuarios (id),
        FOREIGN KEY (livroId) REFERENCES Livros (id)
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
