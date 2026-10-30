import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'pages/catalogo_page.dart';
import 'state/carrinho_model.dart';
import 'state/pedidos_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // No desktop o sqflite precisa da versão FFI. No Android/iOS não precisa.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    // Os providers ficam ACIMA do MaterialApp: todas as telas enxergam os dois.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarrinhoModel()),
        // carregar() já busca os pedidos salvos assim que o app abre.
        ChangeNotifierProvider(create: (_) => PedidosModel()..carregar()),
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