import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../DataModel/pokemon.dart';
import '../../Services/capture_manager.dart';
import '../../Services/favorites_manager.dart';
import '../../Services/pokemon_service.dart';
import '../Cards/random_pokemon_card.dart';

// CatchScreen ("capturar" pokémones)
class CatchScreen extends StatefulWidget {
  final TextStyle textStyle;
  const CatchScreen({super.key, required this.textStyle});

  @override
  State<CatchScreen> createState() => _CatchScreenState();
}

class _CatchScreenState extends State<CatchScreen> {
  // servicio de red
  final PokemonService _pokemonService = PokemonService();

  // almacena un Future marcado como late
  // late permite inicializar una variable inmediatamente en init
  late Future<Pokemon> _currentPokemonFuture;

  @override
  void initState() {
    super.initState();
    // se realiza la primera búsqueda aleatoria al entrar a la pantalla
    _loadRandomPokemon();
  }

  // Pokemon aleatorio
  void _loadRandomPokemon() {
    // setState para notificar sobre el nuevo Future de datos
    setState(() {
      _currentPokemonFuture = _pokemonService.fetchRandomPokemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Atrapa un Pokémon!"),
      ),
      body: FutureBuilder<Pokemon>(
        future: _currentPokemonFuture,
        builder: (context, snapshot) {
          // indicador de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
            // error
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al buscar Pokémon: ${snapshot.error}'));
            // éxito (datos disponibles)
          } else if (snapshot.hasData) {
            final pokemon = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: RandomPokemonCard(
                    pokemon: pokemon,
                    onCapture: (p) {
                      // cambia el estado global de listen a false cuando no necesita actualizarse
                      Provider.of<CaptureManager>(context, listen: false).capturePokemon(p);
                      // mensaje de confirmación de captura
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('¡Has capturado a ${p.name}!')),
                      );
                      // carga un nuevo pokemon tras capturar
                      _loadRandomPokemon();
                    },
                  ),
                ),
                // botón saltar
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    onPressed: _loadRandomPokemon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: const Text('Saltar'),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No se encontró Pokémon.'));
          }
        },
      ),
    );
  }
}
