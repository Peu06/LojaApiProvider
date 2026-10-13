import 'package:flutter/foundation.dart';

import '../models/produto.dart';

/// Estado de APLICAÇÃO: o carrinho é lido e alterado por várias telas.
class CarrinhoModel extends ChangeNotifier {
  // Estado privado: só o próprio modelo altera.
  final Map<String, int> _quantidades = {}; // sku -> quantidade
  final Map<String, Produto> _produtos = {}; // sku -> produto

  // Leitura segura (a UI não consegue alterar as coleções).
  List<Produto> get produtos => List.unmodifiable(_produtos.values);
  int quantidadeDe(String sku) => _quantidades[sku] ?? 0;
  bool get vazio => _quantidades.isEmpty;

  // Estado derivado: calculado, não armazenado.
  int get totalItens => _quantidades.values.fold<int>(0, (soma, q) => soma + q);
  double get valorTotal => _quantidades.entries.fold<double>(
      0, (soma, e) => soma + e.value * _produtos[e.key]!.preco);

  /// Retorna false (e não notifica) se não houver estoque.
  bool adicionar(Produto produto) {
    final atual = quantidadeDe(produto.sku);
    if (atual >= produto.estoque) return false;
    _produtos[produto.sku] = produto;
    _quantidades[produto.sku] = atual + 1;
    notifyListeners();
    return true;
  }

  /// Diminui 1 da quantidade. Ao chegar a 0, o produto sai das duas coleções.
  /// Se o produto não estiver no carrinho, nada muda e ninguém é avisado.
  void remover(Produto produto) {
    final atual = quantidadeDe(produto.sku);
    if (atual == 0) return;
    if (atual == 1) {
      _quantidades.remove(produto.sku);
      _produtos.remove(produto.sku);
    } else {
      _quantidades[produto.sku] = atual - 1;
    }
    notifyListeners();
  }

  /// Esvazia o carrinho e avisa os ouvintes, mas só se ele não estiver vazio.
  void limpar() {
    if (vazio) return;
    _quantidades.clear();
    _produtos.clear();
    notifyListeners();
  }
}
