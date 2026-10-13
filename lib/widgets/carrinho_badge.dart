import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/checkout_page.dart';
import '../state/carrinho_model.dart';

class CarrinhoBadge extends StatelessWidget {
  const CarrinhoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final qtd = context.select<CarrinhoModel, int>((c) => c.totalItens);
    debugPrint('build CarrinhoBadge ($qtd)');
    return IconButton(
      tooltip: 'Carrinho',
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CheckoutPage()),
      ),
      icon: Badge(
        isLabelVisible: qtd > 0,
        label: Text('$qtd'),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
