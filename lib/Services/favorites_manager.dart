// lib/Services/favorites_manager.dart

// foundation da acceso a ChangeNotifier, que será usado por Provider
import 'package:flutter/foundation.dart';

// import de datamodel
import '../DataModel/pokemon.dart';

// import de shared preferences para almacenar IDs de favoritos
import 'package:pokemon_mobile_flutter/Services/shared_preferences.dart';

import 'pokemon_service.dart';

class FavoritesManager extends ChangeNotifier {
  final PrefsService _prefs = PrefsService();
  final PokemonService _api = PokemonService();

  // set de IDs para búsqueda rápida (usado para comprobaciones de estado)
  final Set<int> _favoritePokemonIds = {};

  // lista de objetos Pokemon para visualización detallada
  final List<Pokemon> _favoritePokemonList = [];

  List<Pokemon> get favoritePokemonList => _favoritePokemonList;

  // getters públicos
  // obtener la lista de pokemones favoritos
  // devuelve los datos completos de cada pokemon favorito
  Future<void> loadFavorites() async {
    final savedIds = await _prefs.getFavorites();
    _favoritePokemonIds.addAll(savedIds);

    if (_favoritePokemonIds.isNotEmpty) {
      for (int id in _favoritePokemonIds) {
        try {
          final p = await _api.fetchPokemon(id);
          _favoritePokemonList.add(p);
        } catch (e) { /* Manejar error de red */ }
      }
    }
    notifyListeners();
  }

  // obtener el estado de favorito de un pokemon
  // más rápido que comparar IDs de la lista detallada
  bool isFavorite(Pokemon pokemon) => _favoritePokemonIds.contains(pokemon.id);

  // agregar un pokemon a favoritos
  // actualiza tanto el set como la lista con la información del pokemon
  void toggleFavorite(Pokemon pokemon) async {
    // verificación de que el pokemon no se encuentra en la lista
    if (isFavorite(pokemon)) {
      _favoritePokemonIds.remove(pokemon.id);
      _favoritePokemonList.removeWhere((p) => p.id == pokemon.id);
    } else {
      _favoritePokemonIds.add(pokemon.id);
      _favoritePokemonList.add(pokemon);
    }
    // guardar lista de IDs favoritos
    await _prefs.saveFavorites(_favoritePokemonIds.toList());

    // notificar a los oyentes
    notifyListeners();
  }
}