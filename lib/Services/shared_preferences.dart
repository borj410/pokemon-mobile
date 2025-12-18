// lib/Services/prefs_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String _favsKey = 'favorite_pokemon_ids';

  // guardar lista de favoritos
  Future<void> saveFavorites(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    // convertir la lista de int a string
    await prefs.setStringList(_favsKey, ids.map((id) => id.toString()).toList());
  }

  // cargar lista de favoritos
  Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favs = prefs.getStringList(_favsKey);
    if (favs == null) return [];
    return favs.map((id) => int.parse(id)).toList();
  }
}