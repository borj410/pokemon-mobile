import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../DataModel/pokemon.dart';
import '../../Services/favorites_manager.dart';
import '../Cards/pokemon_card.dart';

// FavoritesScreen
class FavoritesScreen extends StatelessWidget {
  final TextStyle textStyle;
  const FavoritesScreen({super.key, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    final favoritesManager = Provider.of<FavoritesManager>(context); // provider, permite "escuchar" cambios
    final favoriteList = favoritesManager.favoritePokemonList; // lista de pokemones favoritos

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Favoritos"),
      ),
      // comprobar si la lista tiene elementos
      body: favoriteList.isEmpty
      // si la lista está vacía: mensaje inicial
          ? Center(
        child: Text(
          'Aún no tienes Pokémones favoritos...',
          style: textStyle.copyWith(color: Colors.grey),
        ),
      )
      // si la lista no está vacía: se muestran los elementos
          : GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 tarjetas por fila
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        // la cantidad de elementos es igual a la longitud de la lista
        itemCount: favoriteList.length,
        itemBuilder: (context, index) {
          final pokemon = favoriteList[index];
          // PokemonCard para Favoritos
          return PokemonCard(pokemon: pokemon);
        },
      ),
    );
  }
}