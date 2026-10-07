import 'package:flutter/material.dart';
import 'screens/catalog_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyPartsApp());
}

class MyPartsApp extends StatelessWidget {
  const MyPartsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyParts',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const CatalogScreen(),
    );
  }
}
