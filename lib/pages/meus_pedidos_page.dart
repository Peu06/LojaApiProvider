import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/pedidos_model.dart';
import '../util/formatar.dart';

class MeusPedidosPage extends StatelessWidget {
  const MeusPedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus pedidos')),
      body: Consumer<PedidosModel>(
        builder: (context, model, _) {
          if (model.pedidos.isEmpty) {
            return const Center(child: Text('Nenhum pedido ainda'));
          }
          return ListView.builder(
            itemCount: model.pedidos.length,
            itemBuilder: (context, i) {
              final p = model.pedidos[i];
              return ExpansionTile(
                title: Text('Pedido #${p.id} · ${formatarPreco(p.total)}'),
                subtitle: Text(formatarData(p.data)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => model.excluir(p.id!),
                ),
                children: [
                  FutureBuilder(
                    future: model.repo.itensDo(p.id!),
                    builder: (context, snap) {
                      final itens = snap.data ?? [];
                      return Column(
                        children: [
                          for (final it in itens)
                            ListTile(
                              dense: true,
                              title: Text(it.nome),
                              trailing: Text(
                                  '${it.quantidade} × ${formatarPreco(it.preco)}'),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}