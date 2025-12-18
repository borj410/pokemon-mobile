// lib/Services/capture_manager.dart

// foundation da acceso a ChangeNotifier, que será usado por Provider
import 'package:flutter/foundation.dart';

// import de datamodel
import '../DataModel/pokemon.dart';

// CaptureManager extiende ChangeNotifier
// como indica su nombre, notifica de cambios en los datos internos a los
// widgets que estén "escuchando" (sirve para actualizar la lista de capturados)
class CaptureManager extends ChangeNotifier {
  // lista de pokémones capturados
  final List<Pokemon> _capturedPokemon = [];

  // getter: permite acceder a los datos de la lista
  List<Pokemon> get capturedPokemon => _capturedPokemon;

  // lógica de estados
  void capturePokemon(Pokemon pokemon) {
    // evitar duplicados (dos Pokemon con la misma id son el mismo Pokemon)
    // se usa una negación al principio para usar el caso en el que no hay duplicados
    if (!_capturedPokemon.any((p) => p.id == pokemon.id)) {
      // se añade el nuevo Pokemon a la lista de capturados
      _capturedPokemon.add(pokemon);
      // notifica a los widgets que están escuchando (en este caso CapturedScreen)
      // esto permite que la lista se actualice y se muestre correctamente
      notifyListeners();
    }
  }
}