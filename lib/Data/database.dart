// lib/Data/database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class CapturedPokemons extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get imageUrl => text()();
  TextColumn get types => text()();
  TextColumn get abilities => text()();
  IntColumn get height => integer()();
  IntColumn get weight => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CapturedPokemons])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> addCaptured(CapturedPokemonsCompanion entry) => into(capturedPokemons).insert(entry);

  Future<List<CapturedPokemon>> getAllCaptured() => select(capturedPokemons).get();

  Stream<List<CapturedPokemon>> watchCaptured() => select(capturedPokemons).watch();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pokemon.db'));
    return NativeDatabase(file);
  });
}