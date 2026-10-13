import 'package:flutter/foundation.dart';

/// Desafio (Parte 10): SKUs favoritos.
class FavoritosModel extends ChangeNotifier {
  final Set<String> _skus = {};

  bool eFavorito(String sku) => _skus.contains(sku);
  int get total => _skus.length;

  void alternar(String sku) {
    if (!_skus.remove(sku)) _skus.add(sku);
    notifyListeners();
  }
}
