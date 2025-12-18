import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../DataModel/pokemon.dart';
import '../../Services/favorites_manager.dart';

// RandomPokemonCard (tarjeta simple, usada en CaptureScreen)
class RandomPokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  // función de callback, permite manejar la lógica de capturar un pokemon
  final Function(Pokemon) onCapture;

  const RandomPokemonCard({super.key, required this.pokemon, required this.onCapture});

  @override
  Widget build(BuildContext context) {
    // lógica de favoritos
    final favoritesManager = Provider.of<FavoritesManager>(context);// provider, permite "escuchar" el estado de favorito
    final isFavorite = favoritesManager.isFavorite(pokemon); // determina si un pokemon es favorito o no

    // estilos para pokemones favoritos
    final Color cardColor = isFavorite ? Colors.yellow : Colors.white;
    final Color borderColor = isFavorite ? Colors.red : Colors.grey;

    return Center(
      // Container controla el tamaño máximo
      child: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.8, // controla que ocupe el 80% de la pantalla
        child: Card(
          // color y borde especial
          color: cardColor,
          elevation: isFavorite ? 10 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: borderColor,
              width: isFavorite ? 4.0 : 1.0, // borde rojo para favorito
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // nombre
                    Text(
                      pokemon.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    // ícono de estrella para pokemon favorito
                    if (isFavorite)
                      Icon(Icons.star, color: Colors.amber, size: 30),
                    // id
                    Text(
                      '#${pokemon.id.toString().padLeft(3, '0')}',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              // imagen de tamaño fijo
              SizedBox(
                height: 200,
                // Image.network con url de imagen
                child: Image.network(pokemon.imageUrl, fit: BoxFit.contain),
              ),
              SizedBox(height: 10),

              // tipos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8.0,
                  // lista de tipos en Chips
                  children: pokemon.types.map((type) => Chip(
                    label: Text(type, style: const TextStyle(fontSize: 14, color: Colors.white)),
                    backgroundColor: Colors.red,
                  )).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // botón de capturar
              IconButton(
                icon: const Icon(Icons.catching_pokemon, color: Colors.red, size: 48),
                // callback onCapture
                onPressed: () => onCapture(pokemon),
                tooltip: 'Capturar',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
