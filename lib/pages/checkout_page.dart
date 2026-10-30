import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/carrinho_model.dart';
import '../state/pedidos_model.dart';
import '../util/formatar.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      // Consumer: só o corpo da lista reconstrói, não o Scaffold inteiro.
      body: Consumer<CarrinhoModel>(
        builder: (context, carrinho, child) {
          if (carrinho.vazio) {
            return const Center(child: Text('Seu carrinho está vazio'));
          }
          final itens = carrinho.produtos;
          return ListView.builder(
            itemCount: itens.length,
            itemBuilder: (context, i) {
              final p = itens[i];
              final qtd = carrinho.quantidadeDe(p.sku);
              return ListTile(
                title: Text(p.nome),
                subtitle: Text(
                    '$qtd × ${formatarPreco(p.preco)} = ${formatarPreco(qtd * p.preco)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => carrinho.remover(p),
                    ),
                    Text('$qtd'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => carrinho.adicionar(p),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Consumer<CarrinhoModel>(
                  builder: (context, c, child) => Text(
                    'Total: ${formatarPreco(c.valorTotal)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              // Selector: o botão só reconstrói quando vazio <-> não vazio.
              Selector<CarrinhoModel, bool>(
                selector: (context, c) => !c.vazio,
                builder: (context, temItens, child) {
                  debugPrint('build botão Finalizar ($temItens)');
                  return FilledButton(
                    onPressed: temItens ? () => _finalizar(context) : null,
                    child: const Text('Finalizar'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Agora é async: grava o pedido no SQLite antes de fechar a tela.
  Future<void> _finalizar(BuildContext context) async {
    final carrinho = context.read<CarrinhoModel>();
    final pedidos = context.read<PedidosModel>();
    final total = carrinho.valorTotal; // lê ANTES de limpar
    // Guardar antes do await: não usar o context depois de uma pausa assíncrona.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Grava no banco, limpa o carrinho e recarrega a lista de pedidos.
    await pedidos.finalizar(carrinho);

    messenger.showSnackBar(
      SnackBar(content: Text('Pedido de ${formatarPreco(total)} salvo no banco!')),
    );
    navigator.pop();
  }
}