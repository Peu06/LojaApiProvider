class ItemPedido {
  final String nome;
  final double preco;
  final int quantidade;
  const ItemPedido({required this.nome, required this.preco, required this.quantidade});

  Map<String, Object?> toMap(int pedidoId) => {
        'pedido_id': pedidoId,
        'nome': nome,
        'preco': preco,
        'quantidade': quantidade,
      };

  factory ItemPedido.fromMap(Map<String, Object?> m) => ItemPedido(
        nome: m['nome'] as String,
        preco: (m['preco'] as num).toDouble(),
        quantidade: m['quantidade'] as int,
      );
}

class Pedido {
  final int? id;
  final DateTime data;
  final double total;
  final List<ItemPedido> itens;
  const Pedido({this.id, required this.data, required this.total, this.itens = const []});

  Map<String, Object?> toMap() => {'data': data.toIso8601String(), 'total': total};

  factory Pedido.fromMap(Map<String, Object?> m) => Pedido(
        id: m['id'] as int,
        data: DateTime.parse(m['data'] as String),
        total: (m['total'] as num).toDouble(),
      );
}