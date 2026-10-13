/// Entidade imutável: um produto do catálogo.
class Produto {
  final String sku;
  final String nome;
  final double preco;
  final int estoque;

  const Produto({
    required this.sku,
    required this.nome,
    required this.preco,
    required this.estoque,
  });
}
