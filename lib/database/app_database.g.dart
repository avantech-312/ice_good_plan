// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GearTable extends Gear with TableInfo<$GearTable, GearData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GearTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    brand,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gear';
  @override
  VerificationContext validateIntegrity(
    Insertable<GearData> instance, {
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GearData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GearData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GearTable createAlias(String alias) {
    return $GearTable(attachedDatabase, alias);
  }
}

class GearData extends DataClass implements Insertable<GearData> {
  final int id;
  final String name;
  final String type;
  final String? brand;
  final String? notes;
  final DateTime createdAt;
  const GearData({
    required this.id,
    required this.name,
    required this.type,
    this.brand,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GearCompanion toCompanion(bool nullToAbsent) {
    return GearCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory GearData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GearData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      brand: serializer.fromJson<String?>(json['brand']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'brand': serializer.toJson<String?>(brand),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GearData copyWith({
    int? id,
    String? name,
    String? type,
    Value<String?> brand = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => GearData(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    brand: brand.present ? brand.value : this.brand,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  GearData copyWithCompanion(GearCompanion data) {
    return GearData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      brand: data.brand.present ? data.brand.value : this.brand,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GearData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('brand: $brand, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, brand, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GearData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.brand == this.brand &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class GearCompanion extends UpdateCompanion<GearData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> brand;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const GearCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.brand = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GearCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.brand = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<GearData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? brand,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (brand != null) 'brand': brand,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GearCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? brand,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return GearCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GearCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('brand: $brand, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CatchesTable extends Catches with TableInfo<$CatchesTable, Catche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _speciesMeta = const VerificationMeta(
    'species',
  );
  @override
  late final GeneratedColumn<String> species = GeneratedColumn<String>(
    'species',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lengthCmMeta = const VerificationMeta(
    'lengthCm',
  );
  @override
  late final GeneratedColumn<double> lengthCm = GeneratedColumn<double>(
    'length_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationNameMeta = const VerificationMeta(
    'locationName',
  );
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
    'location_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gearIdMeta = const VerificationMeta('gearId');
  @override
  late final GeneratedColumn<int> gearId = GeneratedColumn<int>(
    'gear_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gear (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    species,
    weightKg,
    lengthCm,
    date,
    notes,
    locationName,
    gearId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catches';
  @override
  VerificationContext validateIntegrity(
    Insertable<Catche> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('species')) {
      context.handle(
        _speciesMeta,
        species.isAcceptableOrUnknown(data['species']!, _speciesMeta),
      );
    } else if (isInserting) {
      context.missing(_speciesMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('length_cm')) {
      context.handle(
        _lengthCmMeta,
        lengthCm.isAcceptableOrUnknown(data['length_cm']!, _lengthCmMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('location_name')) {
      context.handle(
        _locationNameMeta,
        locationName.isAcceptableOrUnknown(
          data['location_name']!,
          _locationNameMeta,
        ),
      );
    }
    if (data.containsKey('gear_id')) {
      context.handle(
        _gearIdMeta,
        gearId.isAcceptableOrUnknown(data['gear_id']!, _gearIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Catche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Catche(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      species: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}species'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      lengthCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}length_cm'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      locationName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_name'],
      ),
      gearId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gear_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CatchesTable createAlias(String alias) {
    return $CatchesTable(attachedDatabase, alias);
  }
}

class Catche extends DataClass implements Insertable<Catche> {
  final int id;
  final String species;
  final double weightKg;
  final double? lengthCm;
  final DateTime date;
  final String? notes;
  final String? locationName;
  final int? gearId;
  final DateTime createdAt;
  const Catche({
    required this.id,
    required this.species,
    required this.weightKg,
    this.lengthCm,
    required this.date,
    this.notes,
    this.locationName,
    this.gearId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['species'] = Variable<String>(species);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || lengthCm != null) {
      map['length_cm'] = Variable<double>(lengthCm);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    if (!nullToAbsent || gearId != null) {
      map['gear_id'] = Variable<int>(gearId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CatchesCompanion toCompanion(bool nullToAbsent) {
    return CatchesCompanion(
      id: Value(id),
      species: Value(species),
      weightKg: Value(weightKg),
      lengthCm: lengthCm == null && nullToAbsent
          ? const Value.absent()
          : Value(lengthCm),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      gearId: gearId == null && nullToAbsent
          ? const Value.absent()
          : Value(gearId),
      createdAt: Value(createdAt),
    );
  }

  factory Catche.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Catche(
      id: serializer.fromJson<int>(json['id']),
      species: serializer.fromJson<String>(json['species']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      lengthCm: serializer.fromJson<double?>(json['lengthCm']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      gearId: serializer.fromJson<int?>(json['gearId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'species': serializer.toJson<String>(species),
      'weightKg': serializer.toJson<double>(weightKg),
      'lengthCm': serializer.toJson<double?>(lengthCm),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'locationName': serializer.toJson<String?>(locationName),
      'gearId': serializer.toJson<int?>(gearId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Catche copyWith({
    int? id,
    String? species,
    double? weightKg,
    Value<double?> lengthCm = const Value.absent(),
    DateTime? date,
    Value<String?> notes = const Value.absent(),
    Value<String?> locationName = const Value.absent(),
    Value<int?> gearId = const Value.absent(),
    DateTime? createdAt,
  }) => Catche(
    id: id ?? this.id,
    species: species ?? this.species,
    weightKg: weightKg ?? this.weightKg,
    lengthCm: lengthCm.present ? lengthCm.value : this.lengthCm,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
    locationName: locationName.present ? locationName.value : this.locationName,
    gearId: gearId.present ? gearId.value : this.gearId,
    createdAt: createdAt ?? this.createdAt,
  );
  Catche copyWithCompanion(CatchesCompanion data) {
    return Catche(
      id: data.id.present ? data.id.value : this.id,
      species: data.species.present ? data.species.value : this.species,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      lengthCm: data.lengthCm.present ? data.lengthCm.value : this.lengthCm,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      gearId: data.gearId.present ? data.gearId.value : this.gearId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Catche(')
          ..write('id: $id, ')
          ..write('species: $species, ')
          ..write('weightKg: $weightKg, ')
          ..write('lengthCm: $lengthCm, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('locationName: $locationName, ')
          ..write('gearId: $gearId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    species,
    weightKg,
    lengthCm,
    date,
    notes,
    locationName,
    gearId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Catche &&
          other.id == this.id &&
          other.species == this.species &&
          other.weightKg == this.weightKg &&
          other.lengthCm == this.lengthCm &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.locationName == this.locationName &&
          other.gearId == this.gearId &&
          other.createdAt == this.createdAt);
}

class CatchesCompanion extends UpdateCompanion<Catche> {
  final Value<int> id;
  final Value<String> species;
  final Value<double> weightKg;
  final Value<double?> lengthCm;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<String?> locationName;
  final Value<int?> gearId;
  final Value<DateTime> createdAt;
  const CatchesCompanion({
    this.id = const Value.absent(),
    this.species = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.lengthCm = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.locationName = const Value.absent(),
    this.gearId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CatchesCompanion.insert({
    this.id = const Value.absent(),
    required String species,
    required double weightKg,
    this.lengthCm = const Value.absent(),
    required DateTime date,
    this.notes = const Value.absent(),
    this.locationName = const Value.absent(),
    this.gearId = const Value.absent(),
    required DateTime createdAt,
  }) : species = Value(species),
       weightKg = Value(weightKg),
       date = Value(date),
       createdAt = Value(createdAt);
  static Insertable<Catche> custom({
    Expression<int>? id,
    Expression<String>? species,
    Expression<double>? weightKg,
    Expression<double>? lengthCm,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<String>? locationName,
    Expression<int>? gearId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (species != null) 'species': species,
      if (weightKg != null) 'weight_kg': weightKg,
      if (lengthCm != null) 'length_cm': lengthCm,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (locationName != null) 'location_name': locationName,
      if (gearId != null) 'gear_id': gearId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CatchesCompanion copyWith({
    Value<int>? id,
    Value<String>? species,
    Value<double>? weightKg,
    Value<double?>? lengthCm,
    Value<DateTime>? date,
    Value<String?>? notes,
    Value<String?>? locationName,
    Value<int?>? gearId,
    Value<DateTime>? createdAt,
  }) {
    return CatchesCompanion(
      id: id ?? this.id,
      species: species ?? this.species,
      weightKg: weightKg ?? this.weightKg,
      lengthCm: lengthCm ?? this.lengthCm,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      locationName: locationName ?? this.locationName,
      gearId: gearId ?? this.gearId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (species.present) {
      map['species'] = Variable<String>(species.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (lengthCm.present) {
      map['length_cm'] = Variable<double>(lengthCm.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (gearId.present) {
      map['gear_id'] = Variable<int>(gearId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatchesCompanion(')
          ..write('id: $id, ')
          ..write('species: $species, ')
          ..write('weightKg: $weightKg, ')
          ..write('lengthCm: $lengthCm, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('locationName: $locationName, ')
          ..write('gearId: $gearId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TipsTable extends Tips with TableInfo<$TipsTable, Tip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, body, category, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TipsTable createAlias(String alias) {
    return $TipsTable(attachedDatabase, alias);
  }
}

class Tip extends DataClass implements Insertable<Tip> {
  final int id;
  final String title;
  final String body;
  final String category;
  final DateTime createdAt;
  const Tip({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['category'] = Variable<String>(category);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TipsCompanion toCompanion(bool nullToAbsent) {
    return TipsCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      category: Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory Tip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tip(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      category: serializer.fromJson<String>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'category': serializer.toJson<String>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tip copyWith({
    int? id,
    String? title,
    String? body,
    String? category,
    DateTime? createdAt,
  }) => Tip(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
  );
  Tip copyWithCompanion(TipsCompanion data) {
    return Tip(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tip(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, category, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tip &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class TipsCompanion extends UpdateCompanion<Tip> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String> category;
  final Value<DateTime> createdAt;
  const TipsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TipsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String body,
    required String category,
    required DateTime createdAt,
  }) : title = Value(title),
       body = Value(body),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<Tip> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TipsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? body,
    Value<String>? category,
    Value<DateTime>? createdAt,
  }) {
    return TipsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TipsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GearTable gear = $GearTable(this);
  late final $CatchesTable catches = $CatchesTable(this);
  late final $TipsTable tips = $TipsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [gear, catches, tips];
}

typedef $$GearTableCreateCompanionBuilder =
    GearCompanion Function({
      Value<int> id,
      required String name,
      required String type,
      Value<String?> brand,
      Value<String?> notes,
      required DateTime createdAt,
    });
typedef $$GearTableUpdateCompanionBuilder =
    GearCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<String?> brand,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$GearTableReferences
    extends BaseReferences<_$AppDatabase, $GearTable, GearData> {
  $$GearTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CatchesTable, List<Catche>> _catchesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.catches,
    aliasName: $_aliasNameGenerator(db.gear.id, db.catches.gearId),
  );

  $$CatchesTableProcessedTableManager get catchesRefs {
    final manager = $$CatchesTableTableManager(
      $_db,
      $_db.catches,
    ).filter((f) => f.gearId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_catchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GearTableFilterComposer extends Composer<_$AppDatabase, $GearTable> {
  $$GearTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> catchesRefs(
    Expression<bool> Function($$CatchesTableFilterComposer f) f,
  ) {
    final $$CatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.catches,
      getReferencedColumn: (t) => t.gearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatchesTableFilterComposer(
            $db: $db,
            $table: $db.catches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GearTableOrderingComposer extends Composer<_$AppDatabase, $GearTable> {
  $$GearTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GearTableAnnotationComposer
    extends Composer<_$AppDatabase, $GearTable> {
  $$GearTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> catchesRefs<T extends Object>(
    Expression<T> Function($$CatchesTableAnnotationComposer a) f,
  ) {
    final $$CatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.catches,
      getReferencedColumn: (t) => t.gearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.catches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GearTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GearTable,
          GearData,
          $$GearTableFilterComposer,
          $$GearTableOrderingComposer,
          $$GearTableAnnotationComposer,
          $$GearTableCreateCompanionBuilder,
          $$GearTableUpdateCompanionBuilder,
          (GearData, $$GearTableReferences),
          GearData,
          PrefetchHooks Function({bool catchesRefs})
        > {
  $$GearTableTableManager(_$AppDatabase db, $GearTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GearTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GearTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GearTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GearCompanion(
                id: id,
                name: name,
                type: type,
                brand: brand,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                Value<String?> brand = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
              }) => GearCompanion.insert(
                id: id,
                name: name,
                type: type,
                brand: brand,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GearTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({catchesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (catchesRefs) db.catches],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (catchesRefs)
                    await $_getPrefetchedData<GearData, $GearTable, Catche>(
                      currentTable: table,
                      referencedTable: $$GearTableReferences._catchesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$GearTableReferences(db, table, p0).catchesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.gearId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GearTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GearTable,
      GearData,
      $$GearTableFilterComposer,
      $$GearTableOrderingComposer,
      $$GearTableAnnotationComposer,
      $$GearTableCreateCompanionBuilder,
      $$GearTableUpdateCompanionBuilder,
      (GearData, $$GearTableReferences),
      GearData,
      PrefetchHooks Function({bool catchesRefs})
    >;
typedef $$CatchesTableCreateCompanionBuilder =
    CatchesCompanion Function({
      Value<int> id,
      required String species,
      required double weightKg,
      Value<double?> lengthCm,
      required DateTime date,
      Value<String?> notes,
      Value<String?> locationName,
      Value<int?> gearId,
      required DateTime createdAt,
    });
typedef $$CatchesTableUpdateCompanionBuilder =
    CatchesCompanion Function({
      Value<int> id,
      Value<String> species,
      Value<double> weightKg,
      Value<double?> lengthCm,
      Value<DateTime> date,
      Value<String?> notes,
      Value<String?> locationName,
      Value<int?> gearId,
      Value<DateTime> createdAt,
    });

final class $$CatchesTableReferences
    extends BaseReferences<_$AppDatabase, $CatchesTable, Catche> {
  $$CatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GearTable _gearIdTable(_$AppDatabase db) =>
      db.gear.createAlias($_aliasNameGenerator(db.catches.gearId, db.gear.id));

  $$GearTableProcessedTableManager? get gearId {
    final $_column = $_itemColumn<int>('gear_id');
    if ($_column == null) return null;
    final manager = $$GearTableTableManager(
      $_db,
      $_db.gear,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gearIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CatchesTableFilterComposer
    extends Composer<_$AppDatabase, $CatchesTable> {
  $$CatchesTableFilterComposer({
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

  ColumnFilters<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lengthCm => $composableBuilder(
    column: $table.lengthCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GearTableFilterComposer get gearId {
    final $$GearTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gearId,
      referencedTable: $db.gear,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GearTableFilterComposer(
            $db: $db,
            $table: $db.gear,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatchesTable> {
  $$CatchesTableOrderingComposer({
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

  ColumnOrderings<String> get species => $composableBuilder(
    column: $table.species,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lengthCm => $composableBuilder(
    column: $table.lengthCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GearTableOrderingComposer get gearId {
    final $$GearTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gearId,
      referencedTable: $db.gear,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GearTableOrderingComposer(
            $db: $db,
            $table: $db.gear,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatchesTable> {
  $$CatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get species =>
      $composableBuilder(column: $table.species, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get lengthCm =>
      $composableBuilder(column: $table.lengthCm, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
    column: $table.locationName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GearTableAnnotationComposer get gearId {
    final $$GearTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gearId,
      referencedTable: $db.gear,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GearTableAnnotationComposer(
            $db: $db,
            $table: $db.gear,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatchesTable,
          Catche,
          $$CatchesTableFilterComposer,
          $$CatchesTableOrderingComposer,
          $$CatchesTableAnnotationComposer,
          $$CatchesTableCreateCompanionBuilder,
          $$CatchesTableUpdateCompanionBuilder,
          (Catche, $$CatchesTableReferences),
          Catche,
          PrefetchHooks Function({bool gearId})
        > {
  $$CatchesTableTableManager(_$AppDatabase db, $CatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> species = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double?> lengthCm = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                Value<int?> gearId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CatchesCompanion(
                id: id,
                species: species,
                weightKg: weightKg,
                lengthCm: lengthCm,
                date: date,
                notes: notes,
                locationName: locationName,
                gearId: gearId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String species,
                required double weightKg,
                Value<double?> lengthCm = const Value.absent(),
                required DateTime date,
                Value<String?> notes = const Value.absent(),
                Value<String?> locationName = const Value.absent(),
                Value<int?> gearId = const Value.absent(),
                required DateTime createdAt,
              }) => CatchesCompanion.insert(
                id: id,
                species: species,
                weightKg: weightKg,
                lengthCm: lengthCm,
                date: date,
                notes: notes,
                locationName: locationName,
                gearId: gearId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gearId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (gearId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gearId,
                                referencedTable: $$CatchesTableReferences
                                    ._gearIdTable(db),
                                referencedColumn: $$CatchesTableReferences
                                    ._gearIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatchesTable,
      Catche,
      $$CatchesTableFilterComposer,
      $$CatchesTableOrderingComposer,
      $$CatchesTableAnnotationComposer,
      $$CatchesTableCreateCompanionBuilder,
      $$CatchesTableUpdateCompanionBuilder,
      (Catche, $$CatchesTableReferences),
      Catche,
      PrefetchHooks Function({bool gearId})
    >;
typedef $$TipsTableCreateCompanionBuilder =
    TipsCompanion Function({
      Value<int> id,
      required String title,
      required String body,
      required String category,
      required DateTime createdAt,
    });
typedef $$TipsTableUpdateCompanionBuilder =
    TipsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> body,
      Value<String> category,
      Value<DateTime> createdAt,
    });

class $$TipsTableFilterComposer extends Composer<_$AppDatabase, $TipsTable> {
  $$TipsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TipsTableOrderingComposer extends Composer<_$AppDatabase, $TipsTable> {
  $$TipsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TipsTable> {
  $$TipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TipsTable,
          Tip,
          $$TipsTableFilterComposer,
          $$TipsTableOrderingComposer,
          $$TipsTableAnnotationComposer,
          $$TipsTableCreateCompanionBuilder,
          $$TipsTableUpdateCompanionBuilder,
          (Tip, BaseReferences<_$AppDatabase, $TipsTable, Tip>),
          Tip,
          PrefetchHooks Function()
        > {
  $$TipsTableTableManager(_$AppDatabase db, $TipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TipsCompanion(
                id: id,
                title: title,
                body: body,
                category: category,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String body,
                required String category,
                required DateTime createdAt,
              }) => TipsCompanion.insert(
                id: id,
                title: title,
                body: body,
                category: category,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TipsTable,
      Tip,
      $$TipsTableFilterComposer,
      $$TipsTableOrderingComposer,
      $$TipsTableAnnotationComposer,
      $$TipsTableCreateCompanionBuilder,
      $$TipsTableUpdateCompanionBuilder,
      (Tip, BaseReferences<_$AppDatabase, $TipsTable, Tip>),
      Tip,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GearTableTableManager get gear => $$GearTableTableManager(_db, _db.gear);
  $$CatchesTableTableManager get catches =>
      $$CatchesTableTableManager(_db, _db.catches);
  $$TipsTableTableManager get tips => $$TipsTableTableManager(_db, _db.tips);
}
