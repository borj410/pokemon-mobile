// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CapturedPokemonsTable extends CapturedPokemons
    with TableInfo<$CapturedPokemonsTable, CapturedPokemon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CapturedPokemonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typesMeta = const VerificationMeta('types');
  @override
  late final GeneratedColumn<String> types = GeneratedColumn<String>(
    'types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abilitiesMeta = const VerificationMeta(
    'abilities',
  );
  @override
  late final GeneratedColumn<String> abilities = GeneratedColumn<String>(
    'abilities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    imageUrl,
    types,
    abilities,
    height,
    weight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'captured_pokemons';
  @override
  VerificationContext validateIntegrity(
    Insertable<CapturedPokemon> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('types')) {
      context.handle(
        _typesMeta,
        types.isAcceptableOrUnknown(data['types']!, _typesMeta),
      );
    } else if (isInserting) {
      context.missing(_typesMeta);
    }
    if (data.containsKey('abilities')) {
      context.handle(
        _abilitiesMeta,
        abilities.isAcceptableOrUnknown(data['abilities']!, _abilitiesMeta),
      );
    } else if (isInserting) {
      context.missing(_abilitiesMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CapturedPokemon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CapturedPokemon(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      types: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}types'],
      )!,
      abilities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abilities'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weight'],
      )!,
    );
  }

  @override
  $CapturedPokemonsTable createAlias(String alias) {
    return $CapturedPokemonsTable(attachedDatabase, alias);
  }
}

class CapturedPokemon extends DataClass implements Insertable<CapturedPokemon> {
  final int id;
  final String name;
  final String imageUrl;
  final String types;
  final String abilities;
  final int height;
  final int weight;
  const CapturedPokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.abilities,
    required this.height,
    required this.weight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['image_url'] = Variable<String>(imageUrl);
    map['types'] = Variable<String>(types);
    map['abilities'] = Variable<String>(abilities);
    map['height'] = Variable<int>(height);
    map['weight'] = Variable<int>(weight);
    return map;
  }

  CapturedPokemonsCompanion toCompanion(bool nullToAbsent) {
    return CapturedPokemonsCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: Value(imageUrl),
      types: Value(types),
      abilities: Value(abilities),
      height: Value(height),
      weight: Value(weight),
    );
  }

  factory CapturedPokemon.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CapturedPokemon(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      types: serializer.fromJson<String>(json['types']),
      abilities: serializer.fromJson<String>(json['abilities']),
      height: serializer.fromJson<int>(json['height']),
      weight: serializer.fromJson<int>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'types': serializer.toJson<String>(types),
      'abilities': serializer.toJson<String>(abilities),
      'height': serializer.toJson<int>(height),
      'weight': serializer.toJson<int>(weight),
    };
  }

  CapturedPokemon copyWith({
    int? id,
    String? name,
    String? imageUrl,
    String? types,
    String? abilities,
    int? height,
    int? weight,
  }) => CapturedPokemon(
    id: id ?? this.id,
    name: name ?? this.name,
    imageUrl: imageUrl ?? this.imageUrl,
    types: types ?? this.types,
    abilities: abilities ?? this.abilities,
    height: height ?? this.height,
    weight: weight ?? this.weight,
  );
  CapturedPokemon copyWithCompanion(CapturedPokemonsCompanion data) {
    return CapturedPokemon(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      types: data.types.present ? data.types.value : this.types,
      abilities: data.abilities.present ? data.abilities.value : this.abilities,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CapturedPokemon(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('types: $types, ')
          ..write('abilities: $abilities, ')
          ..write('height: $height, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, imageUrl, types, abilities, height, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CapturedPokemon &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.types == this.types &&
          other.abilities == this.abilities &&
          other.height == this.height &&
          other.weight == this.weight);
}

class CapturedPokemonsCompanion extends UpdateCompanion<CapturedPokemon> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> imageUrl;
  final Value<String> types;
  final Value<String> abilities;
  final Value<int> height;
  final Value<int> weight;
  const CapturedPokemonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.types = const Value.absent(),
    this.abilities = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
  });
  CapturedPokemonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String imageUrl,
    required String types,
    required String abilities,
    required int height,
    required int weight,
  }) : name = Value(name),
       imageUrl = Value(imageUrl),
       types = Value(types),
       abilities = Value(abilities),
       height = Value(height),
       weight = Value(weight);
  static Insertable<CapturedPokemon> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<String>? types,
    Expression<String>? abilities,
    Expression<int>? height,
    Expression<int>? weight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (types != null) 'types': types,
      if (abilities != null) 'abilities': abilities,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
    });
  }

  CapturedPokemonsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? imageUrl,
    Value<String>? types,
    Value<String>? abilities,
    Value<int>? height,
    Value<int>? weight,
  }) {
    return CapturedPokemonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      types: types ?? this.types,
      abilities: abilities ?? this.abilities,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (types.present) {
      map['types'] = Variable<String>(types.value);
    }
    if (abilities.present) {
      map['abilities'] = Variable<String>(abilities.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CapturedPokemonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('types: $types, ')
          ..write('abilities: $abilities, ')
          ..write('height: $height, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CapturedPokemonsTable capturedPokemons = $CapturedPokemonsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [capturedPokemons];
}

typedef $$CapturedPokemonsTableCreateCompanionBuilder =
    CapturedPokemonsCompanion Function({
      Value<int> id,
      required String name,
      required String imageUrl,
      required String types,
      required String abilities,
      required int height,
      required int weight,
    });
typedef $$CapturedPokemonsTableUpdateCompanionBuilder =
    CapturedPokemonsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> imageUrl,
      Value<String> types,
      Value<String> abilities,
      Value<int> height,
      Value<int> weight,
    });

class $$CapturedPokemonsTableFilterComposer
    extends Composer<_$AppDatabase, $CapturedPokemonsTable> {
  $$CapturedPokemonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get types => $composableBuilder(
    column: $table.types,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abilities => $composableBuilder(
    column: $table.abilities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CapturedPokemonsTableOrderingComposer
    extends Composer<_$AppDatabase, $CapturedPokemonsTable> {
  $$CapturedPokemonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get types => $composableBuilder(
    column: $table.types,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abilities => $composableBuilder(
    column: $table.abilities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CapturedPokemonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CapturedPokemonsTable> {
  $$CapturedPokemonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get types =>
      $composableBuilder(column: $table.types, builder: (column) => column);

  GeneratedColumn<String> get abilities =>
      $composableBuilder(column: $table.abilities, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);
}

class $$CapturedPokemonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CapturedPokemonsTable,
          CapturedPokemon,
          $$CapturedPokemonsTableFilterComposer,
          $$CapturedPokemonsTableOrderingComposer,
          $$CapturedPokemonsTableAnnotationComposer,
          $$CapturedPokemonsTableCreateCompanionBuilder,
          $$CapturedPokemonsTableUpdateCompanionBuilder,
          (
            CapturedPokemon,
            BaseReferences<
              _$AppDatabase,
              $CapturedPokemonsTable,
              CapturedPokemon
            >,
          ),
          CapturedPokemon,
          PrefetchHooks Function()
        > {
  $$CapturedPokemonsTableTableManager(
    _$AppDatabase db,
    $CapturedPokemonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CapturedPokemonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CapturedPokemonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CapturedPokemonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String> types = const Value.absent(),
                Value<String> abilities = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> weight = const Value.absent(),
              }) => CapturedPokemonsCompanion(
                id: id,
                name: name,
                imageUrl: imageUrl,
                types: types,
                abilities: abilities,
                height: height,
                weight: weight,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String imageUrl,
                required String types,
                required String abilities,
                required int height,
                required int weight,
              }) => CapturedPokemonsCompanion.insert(
                id: id,
                name: name,
                imageUrl: imageUrl,
                types: types,
                abilities: abilities,
                height: height,
                weight: weight,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CapturedPokemonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CapturedPokemonsTable,
      CapturedPokemon,
      $$CapturedPokemonsTableFilterComposer,
      $$CapturedPokemonsTableOrderingComposer,
      $$CapturedPokemonsTableAnnotationComposer,
      $$CapturedPokemonsTableCreateCompanionBuilder,
      $$CapturedPokemonsTableUpdateCompanionBuilder,
      (
        CapturedPokemon,
        BaseReferences<_$AppDatabase, $CapturedPokemonsTable, CapturedPokemon>,
      ),
      CapturedPokemon,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CapturedPokemonsTableTableManager get capturedPokemons =>
      $$CapturedPokemonsTableTableManager(_db, _db.capturedPokemons);
}
