import 'package:flutter/material.dart';
import 'package:pokemon_mobile_flutter/Widgets/Pages/search_screen.dart';
import 'package:provider/provider.dart';
import '../../Data/constants.dart';
import '../../DataModel/pokemon.dart';
import '../../Services/favorites_manager.dart';
import '../../Services/pokemon_service.dart';
import '../Cards/pokemon_card.dart';
import 'captured_screen.dart';
import 'catch_screen.dart';

// HomeScreen (ver información de todos los pokémones disponibles en orden por id)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // servicio de red
  final PokemonService _pokemonService = PokemonService();
  // lista de pokémones cargados
  final List<Pokemon> _pokemonList = [];

  // objeto que escucha la posición del scroll
  // detecta cuando el usuario llega al final de la pantalla
  final ScrollController _scrollController = ScrollController();

  final int _maxPokemonId = Constants.maxPokemonId; // id máxima de pokemon disponible
  int _nextIdToLoad = 1; // id del próximo pokémon a cargar (inicia en 1)
  final int _pageSize = 20; // tamaño del lote a cargar
  bool _isLoading = false; // sirve para evitar llamadas duplicadas a la API
  bool _hasMore = true; // indica si hay más pokémones disponibles (hasta llegar al máximo)

  // estilo de texto en pantallas de destino
  final TextStyle _screenTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    // carga del primer lote
    _loadMorePokemon();

    // detectar final del scroll, es llamada cada vez que el usuario scrollea
    _scrollController.addListener(() {
      // crompueba si falta poco para llegar al final de la lista (margen de 200 pixeles)
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // carga el siguiente lote de pokemones
        _loadMorePokemon();
      }
    });
  }

  // dispose se utiliza para liberar los recursos asignados al salir de la pantalla
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // cargar el siguiente lote
  Future<void> _loadMorePokemon() async {
    // verifica si no se está realizando una llamada a la API actualmente y si hay más pokemones disponibles
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    }
    );

    try {
      // llamada a la API, espera la respuesta
      final newPokemon = await _pokemonService.fetchPokemonList(
        startId: _nextIdToLoad,
        count: _pageSize,
      );

      // setState para actualizar la interfaz
      setState(() {
        // añade los nuevos pokemones cargados a la lista
        _pokemonList.addAll(newPokemon);
        // avanza el puntero a la siguiente ID inicial
        _nextIdToLoad += newPokemon.length;
        // permite la carga del siguiente lote
        _isLoading = false;

        // límite de 151 (primera generación) definido en Constants
        if (_nextIdToLoad > _maxPokemonId) {
          _hasMore = false;
        }
      });
    } catch (e) {
      // manejo de error
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navegación
  void pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return screen;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Mobile'),
        actions: <Widget>[
          // Botones de navegación
          // Búsqueda
          IconButton(
            onPressed: () => pushScreen(context, SearchScreen(textStyle: _screenTextStyle)),
            icon: const Icon(Icons.search),
            tooltip: 'Buscar Pokémon',
          ),
          // Favoritos
          IconButton(
            onPressed: () => pushScreen(context, FavoritesScreen(textStyle: _screenTextStyle)),
            icon: const Icon(Icons.favorite_border),
            tooltip: 'Favoritos',
          ),
          // Capturados
          IconButton(
            onPressed: () => pushScreen(context, CapturedScreen(textStyle: _screenTextStyle)),
            icon: const Icon(Icons.catching_pokemon),
            tooltip: 'Pokémon Capturados',
          ),
          // Capturar
          IconButton(
            onPressed: () => pushScreen(context, CatchScreen(textStyle: _screenTextStyle)),
            icon: const Icon(Icons.grass),
            tooltip: 'Capturar Pokémon',
          ),
        ],
      ),
      // indicador de carga inicial
      body: _pokemonList.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        // asignar controlador de scroll a gridview
        controller: _scrollController,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        // añade espacio para indicador de carga
        itemCount: _pokemonList.length + (_hasMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= _pokemonList.length) {
            // indicador de carga al final
            return Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }
          final pokemon = _pokemonList[index];
          // PokemonCard para Home
          return PokemonCard(pokemon: pokemon);
        },
      ),
    );
  }
}
