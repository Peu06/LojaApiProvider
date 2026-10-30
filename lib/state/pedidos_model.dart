import 'package:flutter/foundation.dart';
import '../data/pedido_repository.dart';
import '../models/pedido.dart';
import 'carrinho_model.dart';

class PedidosModel extends ChangeNotifier {
  final repo = PedidoRepository();
  List<Pedido> _pedidos = [];
  List<Pedido> get pedidos => List.unmodifiable(_pedidos);

  Future<void> carregar() async {
    _pedidos = await repo.listar();
    notifyListeners();
  }

  Future<void> finalizar(CarrinhoModel carrinho) async {
    if (carrinho.vazio) return; // regra vale antes de gravar
    final itens = carrinho.produtos
        .map((p) => ItemPedido(
            nome: p.nome, preco: p.preco, quantidade: carrinho.quantidadeDe(p.sku)))
        .toList();
    await repo.inserir(
        Pedido(data: DateTime.now(), total: carrinho.valorTotal, itens: itens));
    carrinho.limpar();
    await carregar();
  }

  Future<void> excluir(int id) async {
    await repo.excluir(id);
    await carregar();
  }
}