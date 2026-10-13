import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/catalogo_page.dart';
import 'state/carrinho_model.dart';
import 'state/favoritos_model.dart';

void main() {
  runApp(
    // Os providers ficam ACIMA do MaterialApp: todas as telas enxergam os modelos.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarrinhoModel()),
        ChangeNotifierProvider(create: (_) => FavoritosModel()),
      ],
      child: const LojaApp(),
    ),
  );
}

class LojaApp extends StatelessWidget {
  const LojaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LojaApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CatalogoPage(),
    );
  }
}
