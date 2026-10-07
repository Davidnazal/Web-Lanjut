import 'package:flutter/material.dart';
import 'pages/catalog_page.dart';
import 'theme/app_theme.dart';

/// Titik masuk utama (*entry point*) aplikasi Flutter MyParts.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyPartsApp());
}

/// Widget akar (*root widget*) aplikasi MyParts.
class MyPartsApp extends StatelessWidget {
  const MyPartsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyParts',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CatalogPage(),
    );
  }
}
