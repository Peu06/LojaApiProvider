import 'package:flutter/material.dart';

import '../models/catalogo.dart';
import '../widgets/carrinho_badge.dart';
import '../widgets/produto_card.dart';
import 'meus_pedidos_page.dart';

class CatalogoPage extends StatelessWidget {
  const CatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('build CatalogoPage');
    return Scaffold(
      appBar: AppBar(
        title: const Text('LojaApp'),
        actions: [
          IconButton(
            tooltip: 'Meus pedidos',
            icon: const Icon(Icons.receipt_long),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MeusPedidosPage()),
            ),
          ),
          const CarrinhoBadge(),
        ],
      ),
      body: ListView.builder(
        itemCount: catalogo.length,
        itemBuilder: (context, i) => ProdutoCard(produto: catalogo[i]),
      ),
    );
  }
}