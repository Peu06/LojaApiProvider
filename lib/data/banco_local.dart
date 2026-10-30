import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoLocal {
  BancoLocal._();
  static final BancoLocal instancia = BancoLocal._();
  Database? _db;

  Future<Database> get db async => _db ??= await _abrir();

  Future<Database> _abrir() async {
    final caminho = join(await getDatabasesPath(), 'loja.db');
    return openDatabase(caminho, version: 1, onCreate: _criar);
  }

  Future<void> _criar(Database db, int versao) async {
    await db.execute('''CREATE TABLE pedidos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data TEXT NOT NULL, total REAL NOT NULL)''');
    await db.execute('''CREATE TABLE itens_pedido (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pedido_id INTEGER NOT NULL, nome TEXT NOT NULL,
      preco REAL NOT NULL, quantidade INTEGER NOT NULL)''');
  }
}