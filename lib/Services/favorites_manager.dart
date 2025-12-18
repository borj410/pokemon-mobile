// lib/Services/favorites_manager.dart

// foundation da acceso a ChangeNotifier, que será usado por Provider
import 'package:flutter/foundation.dart';

// import de datamodel
import '../DataModel/pokemon.dart';

class FavoritesManager extends ChangeNotifier {
  // set de IDs para búsqueda rápida (usado para comprobaciones de estado)
  final Set<int> _favoritePokemonIds = {};

  // lista de objetos Pokemon para visualización detallada
  final List<Pokemon> _favoritePokemonList = [];

  // getters públicos
  // obtener la lista de pokemones favoritos
  // devuelve los datos completos de cada pokemon favorito
  List<Pokemon> get favoritePokemonList => _favoritePokemonList;

  // obtener el estado de favorito de un pokemon
  // más rápido que comparar IDs de la lista detallada
  bool isFavorite(Pokemon pokemon) => _favoritePokemonIds.contains(pokemon.id);

  // agregar un pokemon a favoritos
  // actualiza tanto el set como la lista con la información del pokemon
  void addFavorite(Pokemon pokemon) {
    // verificación de que el pokemon no se encuentra en la lista
    if (!_favoritePokemonIds.contains(pokemon.id)) {
      _favoritePokemonIds.add(pokemon.id);
      _favoritePokemonList.add(pokemon);

      // notifica a los oyentes
      notifyListeners();
    }
  }

  // quitar un pokemon de favoritos
  // elimina la información del pokemon tanto en el set como en la lista
  void removeFavorite(Pokemon pokemon) {
    // verificacion de que el pokemon sí se encuentra en la lista
    if (_favoritePokemonIds.contains(pokemon.id)) {
      _favoritePokemonIds.remove(pokemon.id);
      _favoritePokemonList.removeWhere((p) => p.id == pokemon.id);

      // notifica a los oyentes
      notifyListeners();
    }
  }

  // alternar estado de favorito para un pokemon en específico
  // lógica usada por el botón de favorito
  void toggleFavorite(Pokemon pokemon) {
    // si es favorito, lo elimina de la lista
    if (isFavorite(pokemon)) {
      removeFavorite(pokemon);
    } else {
      // si no es favorito, lo agrega a la lista
      addFavorite(pokemon);
    }
  }
}