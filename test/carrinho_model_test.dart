import 'package:flutter_test/flutter_test.dart';
import 'package:loja_app/models/produto.dart';
import 'package:loja_app/state/carrinho_model.dart';

void main() {
  const teclado =
      Produto(sku: 'TEC-001', nome: 'Teclado', preco: 289.90, estoque: 2);
  const mouse = Produto(sku: 'MOU-002', nome: 'Mouse', preco: 99.90, estoque: 10);

  test('começa vazio', () {
    final c = CarrinhoModel();
    expect(c.vazio, isTrue);
    expect(c.totalItens, 0);
    expect(c.valorTotal, 0);
  });

  test('adicionar soma quantidades e valor, e notifica a cada mudança', () {
    final c = CarrinhoModel();
    var avisos = 0;
    c.addListener(() => avisos++);

    c.adicionar(teclado);
    c.adicionar(mouse);
    c.adicionar(mouse);

    expect(c.totalItens, 3);
    expect(c.quantidadeDe('MOU-002'), 2);
    expect(c.valorTotal, closeTo(489.70, 0.001));
    expect(avisos, 3);
  });

  test('não ultrapassa o estoque e não notifica quando nada muda', () {
    final c = CarrinhoModel();
    var avisos = 0;
    c.addListener(() => avisos++);

    expect(c.adicionar(teclado), isTrue); // 1 de 2
    expect(c.adicionar(teclado), isTrue); // 2 de 2
    expect(c.adicionar(teclado), isFalse); // estoque esgotado

    expect(c.quantidadeDe('TEC-001'), 2);
    expect(c.totalItens, 2);
    expect(avisos, 2); // a tentativa recusada não notificou
  });

  test('remover decrementa e exclui o produto ao chegar a zero', () {
    final c = CarrinhoModel();
    c.adicionar(teclado);
    c.adicionar(teclado);

    var avisos = 0;
    c.addListener(() => avisos++);

    c.remover(teclado);
    expect(c.quantidadeDe('TEC-001'), 1);
    expect(c.produtos, hasLength(1));

    c.remover(teclado);
    expect(c.quantidadeDe('TEC-001'), 0);
    expect(c.produtos, isEmpty);
    expect(c.vazio, isTrue);
    expect(avisos, 2);

    // produto que não está no carrinho: nada muda e ninguém é avisado
    c.remover(mouse);
    expect(avisos, 2);
  });

  test('a lista exposta não pode ser alterada pela interface', () {
    final c = CarrinhoModel();
    c.adicionar(mouse);

    expect(() => c.produtos.add(teclado), throwsUnsupportedError);
    expect(c.produtos, hasLength(1));
    expect(c.totalItens, 1);
  });
}
