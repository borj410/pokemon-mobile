// lib/DataModel/pokemon.dart

class Pokemon {
  // las propiedades con "final" se vuelven inmutables lo que significa que, una vez creadas, no pueden ser modificadas
  // identificador único, usado para construir URLs y modificar atributos
  final int id;
  // nombre en string
  final String name;
  // lista dinámica de habilidades (la respuesta contiene los tipos de datos: Int y String)
  // se almacena la información de 'ability[name]'
  final List<dynamic> abilities;
  // url de la imagen en string
  final String imageUrl;
  // altura (la respuesta devuelve un Int que representa una medida en decímetros (m / 10))
  final int height;
  // peso (la respuesta devuelve un Int que representa una medida en hectogramos (kg / 10))
  final int weight;
  // lista dinámica de tipos (la respuesta contiene los tipos de datos: Int y String)
  // se almacena la información de 'type[name]'
  final List<dynamic> types;

  // constructor
  Pokemon({
    required this.id,
    required this.name,
    required this.abilities,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
  });

  // factory se usa para crear un objeto de la clase Pokemom a partir de la response
  // aquí se define la estructura de datos que esperamos recibir del json
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // nombre
    // se almacena el nombre con la primera letra en mayúscula
    String formattedName = json['name'][0].toUpperCase() + json['name'].substring(1);

    // habilidades (máx 3)
    // almacena la información de ability[name]
    List abilityList = (json['abilities'] as List)
        .take(3)
        .map((abilityData) =>
    // primera letra en mayúscula
    abilityData['ability']['name'][0].toUpperCase() + abilityData['ability']['name'].substring(1))
        .toList();

    // tipos
    // almacena la información de type[name]
    List typeList = (json['types'] as List)
        .map((typeData) =>
    // primera letra en mayúscula
    typeData['type']['name'][0].toUpperCase() + typeData['type']['name'].substring(1))
        .toList();

    // url de la imagen
    // prioriza 'official-artwork', si no está disponible se usa el sprite 'front_default'
    String imageUrl = json['sprites']['other']['official-artwork']['front_default'] ??
        json['sprites']['front_default'];

    // constructor de objeto Pokemon
    return Pokemon(
      id: json['id'], // no es necesario formatear
      name: formattedName, // nombre formateado
      abilities: abilityList, // lista de nombres de habilidades formateados
      imageUrl: imageUrl, // url de imagen a utilizar (official-artwork o front_default)
      height: json['height'], // no es necesario formatear
      weight: json['weight'], // no es necesario formatear
      types: typeList, // lista de nombres de tipos formateados
    );
  }
}