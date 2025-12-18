// lib/Services/capture_manager.dart

import 'package:flutter/foundation.dart';

// import de drift
import 'package:drift/drift.dart' as dr;

// import de datamodel
import '../DataModel/pokemon.dart';

// import de base de datos
import '../Data/database.dart';

// CaptureManager extiende ChangeNotifier
// como indica su nombre, notifica de cambios en los datos internos a los
// widgets que estén "escuchando" (sirve para actualizar la lista de capturados)
class CaptureManager extends ChangeNotifier {
  // AppDatabase
  final AppDatabase _db;

  // lista de pokémones capturados
  List<Pokemon> _capturedPokemon = [];

  // inyección de dependencias
  CaptureManager(this._db);

  List<Pokemon> get capturedPokemon => _capturedPokemon;

  // cargar pokemones desde la base de datos local
  Future<void> loadCapturedFromDb() async {
    final rows = await _db.getAllCaptured();

    // mapear la data de CapturedPokemons (Drift) a modelo Pokemon
    _capturedPokemon = rows.map((row) => Pokemon(
      id: row.id,
      name: row.name,
      imageUrl: row.imageUrl,
      height: row.height,
      weight: row.weight,

      // convertir strings separados por comas de vuelta a list
      types: row.types.split(', '),
      abilities: row.abilities.split(', '),
    )).toList();

    // notifica a los widgets que están escuchando (en este caso CapturedScreen)
    // esto permite que la lista se actualice y se muestre correctamente
    notifyListeners();
  }

  Future<void> capturePokemon(Pokemon pokemon) async {
    if (!_capturedPokemon.any((p) => p.id == pokemon.id)) {

      // insertar en drift
      await _db.addCaptured(CapturedPokemonsCompanion(
        id: dr.Value(pokemon.id),
        name: dr.Value(pokemon.name),
        imageUrl: dr.Value(pokemon.imageUrl),
        height: dr.Value(pokemon.height),
        weight: dr.Value(pokemon.weight),
        // Guardamos las listas como Strings
        types: dr.Value(pokemon.types.join(', ')),
        abilities: dr.Value(pokemon.abilities.join(', ')),
      ));

      _capturedPokemon.add(pokemon);
      notifyListeners();
    }
  }
}