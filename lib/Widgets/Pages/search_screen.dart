import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../DataModel/pokemon.dart';
import '../../Services/favorites_manager.dart';
import '../../Services/pokemon_service.dart';
import '../Cards/pokemon_card.dart';

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
