import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de infraestructura
import 'Data/database.dart';
import 'Services/capture_manager.dart';
import 'Services/favorites_manager.dart';

// Import de la pantalla inicial
import 'Widgets/Pages/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización de persistencia
  final database = AppDatabase();
  final favoritesManager = FavoritesManager();
  final captureManager = CaptureManager(database);

  // Carga inicial de datos persistidos
  await favoritesManager.loadFavorites();
  await captureManager.loadCapturedFromDb();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: captureManager),
        ChangeNotifierProvider.value(value: favoritesManager),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon Mobile by borj410',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}