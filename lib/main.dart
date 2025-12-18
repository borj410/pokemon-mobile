import 'package:flutter/material.dart';

// import de provider
import 'package:provider/provider.dart';

// import de datamodel
import 'DataModel/pokemon.dart';

// imports de services
import 'Services/capture_manager.dart';
import 'Services/favorites_manager.dart';
import 'Services/pokemon_service.dart';

import 'Data/constants.dart';

void main() => runApp(
  // aquí se "inyectan" múltiples instancias de ChangeNotifier
    MultiProvider(
      providers: [
        // se crea una instancia de cada Manager al iniciar la aplicación
        ChangeNotifierProvider(create: (_) => CaptureManager()),   // capturados
        ChangeNotifierProvider(create: (_) => FavoritesManager()), // favoritos
      ],
      child: const MyApp(),
    )
);

// Principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon Mobile by borj410',
      // tema de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.red,
        // color rojo para barras de navegación
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),

      // pantalla de inicio
      home: const HomeScreen(),
    );
  }
}

// ------------------------------------- Cards -------------------------------------

// PokemonCard (tarjeta detallada, usada en HomeScreen y FavoriteScreen)
class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  // color de id
  final Color idColor = Colors.grey;

  const PokemonCard({super.key, required this.pokemon});

  // formato de medidas
  // de decimetros a metros
  // de hectogramos a kilogramos
  String formatHeight(int decimeters) => '${(decimeters / 10).toStringAsFixed(1)} m';
  String formatWeight(int hectograms) => '${(hectograms / 10).toStringAsFixed(1)} kg';

  @override
  Widget build(BuildContext context) {
    // actualizar el botón en base al estado de favorito
    final favoritesManager = Provider.of<FavoritesManager>(context); // provider, permite "escuchar" cambios
    final isFav = favoritesManager.isFavorite(pokemon); // determina si un pokemon es favorito o no

    return Card(
      // elevación y forma
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // contenido de la card: imagen, nombre, tipos, peso, altura, habilidades
            Expanded(
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
                  return const Center(child: Icon(Icons.error, color: Colors.red));
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
              children: pokemon.types.map((type) => Chip(
                label: Text(type, style: TextStyle(fontSize: 10, color: Colors.white)),
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
                Text('Peso: ${formatWeight(pokemon.weight)}', style: const TextStyle(fontSize: 12)),
                Text('Altura: ${formatHeight(pokemon.height)}', style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),

            // habilidades en una lista
            Text(
              'Habilidades:',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            ...pokemon.abilities.map((ability) => Text(
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
      ),
    );
  }
}

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

// ------------------------------------- Pantallas -------------------------------------

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

  final int _maxPokemonId = Constants.maxPokemonId; // id máximade pokemon disponible
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
          childAspectRatio: 0.85,
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

// SearchScreen (buscar información de pokémones por nombre o id)
class SearchScreen extends StatefulWidget {
  final TextStyle textStyle;
  const SearchScreen({super.key, required this.textStyle});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // servicio de red
  final PokemonService _pokemonService = PokemonService();

  // maneja el contenido del TextField
  final TextEditingController _searchController = TextEditingController();

  // Future para estado inicial nulo y resultado
  Future<Pokemon>? _searchResult;
  String? _errorMessage;

  // dispose para liberar recursos
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // búsqueda
  void _performSearch() {
    final query = _searchController.text;

    // validación de consulta vacía
    if (query.isEmpty) {
      setState(() {
        _searchResult = null;
        _errorMessage = "Por favor, ingresa el nombre o la ID de un Pokémon.";
      });
      return;
    }

    // setState para actualizar la interfaz
    setState(() {
      _errorMessage = null;
      // inicio de la búsqueda
      _searchResult = _pokemonService.searchPokemon(query).catchError((e) {
        setState(() {
          // mensaje de error de excepción
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
        // devuelve null en caso de error no usar datos inválidos
        return null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Pokémon"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // barra de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Nombre o ID de Pokémon',
                hintText: 'Ej: Pikachu / 25',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch, // ejecuta la búsqueda al presionar el botón
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              onSubmitted: (_) => _performSearch(), // ejecuta la búsqueda al presionar enter
            ),
            const SizedBox(height: 20),

            // resultados
            Expanded(
              child: _buildResultWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultWidget() {
    // manejo de error
    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: widget.textStyle.copyWith(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    // estado inicial (mensaje de instrucción)
    if (_searchResult == null) {
      return Center(
        child: Text(
          'Ingresa un nombre o ID para comenzar a buscar.',
          style: widget.textStyle.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    // mostrar resultado (Future)
    return FutureBuilder<Pokemon?>(
      future: _searchResult,
      builder: (context, snapshot) {
        // indicador de carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // error (si no se devuelve data)
        if (snapshot.data == null && _errorMessage != null) {
          return const SizedBox.shrink();
        }

        // éxito (si el Future tiene datos)
        if (snapshot.hasData) {
          final pokemon = snapshot.data!;
          // resultado en PokemonCard
          return Center(
            child: SizedBox(
              height: 450,
              width: 300,
              child: PokemonCard(pokemon: pokemon),
            ),
          );
        }

        // estado por defecto
        return Center(
          child: Text(
            'Búsqueda inválida.',
            style: widget.textStyle.copyWith(color: Colors.red),
          ),
        );
      },
    );
  }
}

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
          childAspectRatio: 0.85,
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

// CatchScreen ("capturar" pokémones)
class CatchScreen extends StatefulWidget {
  final TextStyle textStyle;
  const CatchScreen({super.key, required this.textStyle});

  @override
  State<CatchScreen> createState() => _CatchScreenState();
}

class _CatchScreenState extends State<CatchScreen> {
  // servicio de red
  final PokemonService _pokemonService = PokemonService();

  // almacena un Future marcado como late
  // late permite inicializar una variable inmediatamente en init
  late Future<Pokemon> _currentPokemonFuture;

  @override
  void initState() {
    super.initState();
    // se realiza la primera búsqueda aleatoria al entrar a la pantalla
    _loadRandomPokemon();
  }

  // Pokemon aleatorio
  void _loadRandomPokemon() {
    // setState para notificar sobre el nuevo Future de datos
    setState(() {
      _currentPokemonFuture = _pokemonService.fetchRandomPokemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Atrapa un Pokémon!"),
      ),
      body: FutureBuilder<Pokemon>(
        future: _currentPokemonFuture,
        builder: (context, snapshot) {
          // indicador de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
            // error
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al buscar Pokémon: ${snapshot.error}'));
            // éxito (datos disponibles)
          } else if (snapshot.hasData) {
            final pokemon = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: RandomPokemonCard(
                    pokemon: pokemon,
                    onCapture: (p) {
                      // cambia el estado global de listen a false cuando no necesita actualizarse
                      Provider.of<CaptureManager>(context, listen: false).capturePokemon(p);
                      // mensaje de confirmación de captura
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('¡Has capturado a ${p.name}!')),
                      );
                      // carga un nuevo pokemon tras capturar
                      _loadRandomPokemon();
                    },
                  ),
                ),
                // botón saltar
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    onPressed: _loadRandomPokemon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: const Text('Saltar'),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No se encontró Pokémon.'));
          }
        },
      ),
    );
  }
}


// CapturedScreen
class CapturedScreen extends StatelessWidget {
  final TextStyle textStyle;
  const CapturedScreen({super.key, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    final capturedManager = Provider.of<CaptureManager>(context);  // provider, permite "escuchar" cambios

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon Capturados"),
      ),
      // verificar si hay pokemones capturados
      body: capturedManager.capturedPokemon.isEmpty
      // si no hay pokemones capturados: se muestra un mensaje
          ? Center(
        child: Text(
          'Aún no has capturado ningún Pokémon...',
          style: textStyle.copyWith(color: Colors.grey),
        ),
      )
      // si hay pokemones capturados: se muestra la lista
          : ListView.builder(
        itemCount: capturedManager.capturedPokemon.length,
        itemBuilder: (context, index) {
          final pokemon = capturedManager.capturedPokemon[index];
          // vista simplificada (imagen, nombre, tipos e id)
          return ListTile(
            leading: Image.network(pokemon.imageUrl, width: 50, height: 50),
            title: Text(pokemon.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(pokemon.types.join(', ')),
            trailing: Text('#${pokemon.id.toString().padLeft(3, '0')}'),
          );
        },
      ),
    );
  }
}