import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../DataModel/pokemon.dart';
import '../../Services/favorites_manager.dart';

// PokemonCard (tarjeta detallada, usada en HomeScreen y FavoriteScreen)

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  // color de id
  final Color idColor = Colors.grey;

  const PokemonCard({super.key, required this.pokemon});

  // formato de medidas
  // de decimetros a metros
  // de hectogramos a kilogramos
  String formatHeight(int decimeters) =>
      '${(decimeters / 10).toStringAsFixed(1)} m';

  String formatWeight(int hectograms) =>
      '${(hectograms / 10).toStringAsFixed(1)} kg';

  @override
  Widget build(BuildContext context) {
    // actualizar el botón en base al estado de favorito
    final favoritesManager = Provider.of<FavoritesManager>(
        context); // provider, permite "escuchar" cambios
    final isFav = favoritesManager.isFavorite(
        pokemon); // determina si un pokemon es favorito o no

    return Card(
      // elevación y forma
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // contenido de la card: imagen, nombre, tipos, peso, altura, habilidades
                    SizedBox(
                      // tamaño
                      height: constraints.maxWidth * 0.8,
                      // imagen
                      child: Image.network(
                        // src (url de la imagen)
                        pokemon.imageUrl,
                        fit: BoxFit.contain,
                        // indicador de carga
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        // ícono de error
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Icon(Icons.error, color: Colors.red));
                        },
                      ),
                    ),
                    SizedBox(height: 8),

                    // nombre e id en un Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          // nombre
                          child: Text(
                            pokemon.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // id (empieza con #, añade 0s a la izquierda para mostrar 3 dígitos)
                        Text(
                          '#${pokemon.id.toString().padLeft(3, '0')}',
                          style: TextStyle(
                            fontSize: 14,
                            color: idColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    // tipos (en Chips alineados en un wrap)
                    Wrap(
                      spacing: 6.0,
                      children: pokemon.types.map((type) =>
                          Chip(
                            label: Text(type,
                                style: TextStyle(fontSize: 10, color: Colors.white)),
                            backgroundColor: Colors.blue,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.all(0),
                          )).toList(),
                    ),
                    SizedBox(height: 5),
                    // peso y altura en un Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Peso: ${formatWeight(pokemon.weight)}',
                            style: const TextStyle(fontSize: 12)),
                        Text('Altura: ${formatHeight(pokemon.height)}',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // habilidades en una lista
                    Text(
                      'Habilidades:',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    ...pokemon.abilities.map((ability) =>
                        Text(
                          '• $ability',
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(height: 5),

                    // botón de corazón
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        // cambio de estilo (favorite_border gris a favorite rojo)
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border, // ícono
                          color: isFav ? Colors.red : Colors.grey, // color
                        ),
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        // funcionalidad de botón
                        onPressed: () {
                          // cambio de estado de favorito
                          favoritesManager.toggleFavorite(pokemon);
                          // mensaje de confirmación de cambio de estado
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  isFav
                                      ? '¡${pokemon.name} eliminado de Favoritos!'
                                      : '¡${pokemon.name} añadido a Favoritos!'
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      )
    ;
  }
}