// lib/Services/pokemon_service.dart

// imports de packages
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http; // http requests

// import de constants
import '../Data/constants.dart';

// import de datamodel
import '../DataModel/pokemon.dart';

// cliente de API (genera la peticiones, requests)
// contiene la lógica para construir la url de la petición y gestionar la respuesta
class PokemonService {
  // propiedades final: inmutables
  static final String _baseUrl = Constants.baseUrl; // pokeApi
  static final _maxPokemonId = Constants.maxPokemonId; // 151 (primera generación)

  // lista de pokémones obtenidos de forma asíncrona
  Future<List<Pokemon>> fetchPokemonList({required int startId, required int count}) async {
    List<Pokemon> pokemonList = [];

    // esperar peticiones, almacena Futures
    List<Future<Pokemon>> fetchFutures = [];

    // bucle ajustado: va desde startId hasta startId + count - 1
    for (int i = startId; i < startId + count; i++) {
      if (i > _maxPokemonId) break;
      fetchFutures.add(fetchPokemon(i)); // se añaden Futures a la lista
    }

    // await Future.wait sirve para esperar a que todas las peticiones terminen
    // devuelve la lista una vez obtenga los resultados
    pokemonList = await Future.wait(fetchFutures);
    return pokemonList;
  }

  // obtener un pokémon por id
  // utiliza la url base y una id específica
  Future<Pokemon> fetchPokemon(int id) async {
    // convierte el string de la Url con id en un objeto Uri (usado por http)
    // await http.get espera la respuesta del servidor
    final response = await http.get(Uri.parse('$_baseUrl$id'));

    // código de respuesta exitosa: 200 OK
    if (response.statusCode == 200) {
      // jsonDecode(response.body) convierte el string JSON en un Map de Dart
      // el factory constructor permite mapear los datos en un objeto Pokemon
      return Pokemon.fromJson(jsonDecode(response.body));
    } else {
      // manejo de errores
      throw Exception('Failed to load Pokémon with ID: $id');
    }
  }

  // usado en CatchScreen
  // usando _fetchPokemon sobre un id random
  Future<Pokemon> fetchRandomPokemon() async {
    // final: propiedad inmutable
    final int randomId = 1 + Random().nextInt(_maxPokemonId); // id aleatorio entre 1 y el máximo
    return fetchPokemon(randomId);
  }

  // usado en SearchScreen
  // query para buscar un pokémon en base a su nombre o id
  Future<Pokemon> searchPokemon(String query) async {
    // normalizar la consulta (a minúsculas y sin espacios iniciales ni finales)
    final String normalizedQuery = query.toLowerCase().trim();

    // si la consulta está vacía, no se realiza
    if (normalizedQuery.isEmpty) {
      throw Exception('La consulta de búsqueda no puede estar vacía.');
    }

    // la url puede usar el nombre o id para devolver una response para un pokémon específico
    final response = await http.get(Uri.parse('$_baseUrl$normalizedQuery'));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      // error 404
      throw Exception('Pokémon no encontrado: $query');
    }
    else {
      // manejo de otros errores
      throw Exception('Fallo al buscar Pokémon: ${response.statusCode}');
    }
  }
}