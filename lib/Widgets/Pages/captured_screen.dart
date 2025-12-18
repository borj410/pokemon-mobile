import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../DataModel/pokemon.dart';
import '../../Services/capture_manager.dart';
import '../../Services/favorites_manager.dart';

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