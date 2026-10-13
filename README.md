# LojaApp — Aula 01 (Desenvolvimento Mobile / Flutter / UNIP)

Carrinho de compras reativo com Provider.

## Como rodar

Este pacote contém `lib/`, `test/` e `pubspec.yaml`. Para gerar as pastas de
plataforma (android, ios, web, windows) sem mexer no código:

```bash
flutter create loja_app        # numa pasta qualquer
# copie lib/, test/, pubspec.yaml e analysis_options.yaml deste projeto
# por cima dos que o flutter create gerou (apague test/widget_test.dart)
cd loja_app
flutter pub get
flutter run -d chrome
flutter test
```

Ou, dentro desta pasta: `flutter create .` e depois `flutter pub get`.
