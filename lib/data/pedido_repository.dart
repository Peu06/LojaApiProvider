import '../models/pedido.dart';
import 'banco_local.dart';

class PedidoRepository {
  Future<int> inserir(Pedido p) async {
    final db = await BancoLocal.instancia.db;
    return db.transaction((txn) async {
      final id = await txn.insert('pedidos', p.toMap());
      for (final item in p.itens) {
        await txn.insert('itens_pedido', item.toMap(id));
      }
      return id;
    });
  }

  Future<List<Pedido>> listar() async {
    final db = await BancoLocal.instancia.db;
    final linhas = await db.query('pedidos', orderBy: 'id DESC');
    return linhas.map(Pedido.fromMap).toList();
  }

  Future<List<ItemPedido>> itensDo(int pedidoId) async {
    final db = await BancoLocal.instancia.db;
    final linhas = await db.query('itens_pedido',
        where: 'pedido_id = ?', whereArgs: [pedidoId]);
    return linhas.map(ItemPedido.fromMap).toList();
  }

  Future<void> excluir(int id) async {
    final db = await BancoLocal.instancia.db;
    await db.delete('itens_pedido', where: 'pedido_id = ?', whereArgs: [id]);
    await db.delete('pedidos', where: 'id = ?', whereArgs: [id]);
  }
}