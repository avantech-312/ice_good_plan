import 'package:drift/drift.dart' hide Column;
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Catches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get species => text()();
  RealColumn get weightKg => real()();
  RealColumn get lengthCm => real().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get locationName => text().nullable()();
  IntColumn get gearId => integer().nullable().references(Gear, #id)();
  DateTimeColumn get createdAt => dateTime()();
}

class Gear extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class Tips extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get category => text()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Catches, Gear, Tips])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'ice_good_plan_db'));

  @override
  int get schemaVersion => 1;

  Future<List<Catche>> allCatches() {
    final query = select(catches);
    return (query..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Stream<List<Catche>> watchAllCatches() {
    final query = select(catches);
    return (query..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Future<int> insertCatch(CatchesCompanion entry) =>
      into(catches).insert(entry);

  Future<bool> updateCatch(Catche entry) => update(catches).replace(entry);

  Future<int> deleteCatch(Catche entry) =>
      (delete(catches)..where((t) => t.id.equals(entry.id))).go();

  Future<List<GearData>> allGear() {
    final query = select(gear);
    return (query..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Stream<List<GearData>> watchAllGear() {
    final query = select(gear);
    return (query..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  Future<int> insertGear(GearCompanion entry) => into(gear).insert(entry);

  Future<bool> updateGear(GearData entry) => update(gear).replace(entry);

  Future<int> deleteGear(GearData entry) =>
      (delete(gear)..where((t) => t.id.equals(entry.id))).go();

  Future<List<Tip>> allTips() {
    final query = select(tips);
    return (query..orderBy([(t) => OrderingTerm.asc(t.category)])).get();
  }

  Future<double> totalWeight() async {
    final result = await customSelect(
      'SELECT COALESCE(SUM(weight_kg), 0) as total FROM catches',
      readsFrom: {catches},
    ).getSingle();
    final total = result.read<double?>('total');
    return total ?? 0.0;
  }

  Future<int> totalCatchesCount() => select(catches).get().then((l) => l.length);

  Future<List<({String species, int count})>> catchesBySpecies() async {
    final rows = await customSelect(
      'SELECT species, COUNT(*) as count FROM catches GROUP BY species ORDER BY count DESC',
      readsFrom: {catches},
    ).get();
    return rows
        .map((r) => (species: r.read<String>('species'), count: r.read<int>('count')))
        .toList();
  }

  Future<void> seedTipsIfEmpty() async {
    final existing = await select(tips).get();
    if (existing.isNotEmpty) return;
    final now = DateTime.now();
    await batch((batch) {
      batch.insertAll(tips, [
        TipsCompanion.insert(
          title: 'Match the hatch',
          body:
              'Pay attention to what insects or baitfish are active. Fish often feed on the most abundant food source. Try to match your lure or bait to what they\'re eating.',
          category: 'technique',
          createdAt: now,
        ),
        TipsCompanion.insert(
          title: 'Check your line regularly',
          body:
              'Inspect your line for nicks, frays, or weak spots. A damaged line can cause you to lose a big catch. Replace line at least once a season or after landing large fish.',
          category: 'gear',
          createdAt: now,
        ),
        TipsCompanion.insert(
          title: 'Use the right knot',
          body:
              'Different knots work better for different line types and scenarios. Practice the improved clinch, palomar, and uni knots. A poorly tied knot is a common cause of lost fish.',
          category: 'technique',
          createdAt: now,
        ),
        TipsCompanion.insert(
          title: 'Sharp hooks catch more fish',
          body:
              'A dull hook can cost you fish. Sharpen hooks regularly with a small file or stone. Replace hooks that are bent or corroded.',
          category: 'gear',
          createdAt: now,
        ),
        TipsCompanion.insert(
          title: 'Fish early or late',
          body:
              'Dawn and dusk are often the best times to fish. Fish are more active in low light and tend to move into shallower water to feed. Midday can be slow in hot weather.',
          category: 'technique',
          createdAt: now,
        ),
        TipsCompanion.insert(
          title: 'Bring a first aid kit',
          body:
              'Always pack basic first aid: bandages, antiseptic, and any personal medications. Cuts, hooks in skin, and dehydration can happen. Stay safe on the water.',
          category: 'safety',
          createdAt: now,
        ),
        TipsCompanion.insert(
          title: 'Vary your retrieve speed',
          body:
              'If fish aren\'t biting, try changing your retrieve. Sometimes a slow, steady retrieve works; other times a stop-and-go or jerky motion triggers strikes. Experiment.',
          category: 'technique',
          createdAt: now,
        ),
        TipsCompanion.insert(
          title: 'Use live bait when possible',
          body:
              'Live bait often outperforms artificial lures, especially for beginners. Worms, minnows, and insects are natural choices. Keep bait fresh and lively.',
          category: 'bait',
          createdAt: now,
        ),
      ]);
    });
  }

  Future<List<({int month, int year, int count})>> catchesPerMonth() async {
    final rows = await customSelect(
      '''SELECT strftime('%m', date) as month, strftime('%Y', date) as year, COUNT(*) as count 
         FROM catches GROUP BY strftime('%Y', date), strftime('%m', date) ORDER BY year DESC, month DESC LIMIT 12''',
      readsFrom: {catches},
    ).get();
    return rows
        .map((r) => (
              month: int.parse(r.read<String?>('month') ?? '1'),
              year: int.parse(r.read<String?>('year') ?? '1970'),
              count: r.read<int?>('count') ?? 0,
            ))
        .toList();
  }
}
