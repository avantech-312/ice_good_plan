import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/database/app_database.dart';

class DatabaseProvider extends InheritedWidget {
  const DatabaseProvider({
    super.key,
    required this.database,
    required super.child,
  });

  final AppDatabase database;

  static AppDatabase of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<DatabaseProvider>();
    assert(provider != null, 'DatabaseProvider not found');
    return provider!.database;
  }

  @override
  bool updateShouldNotify(DatabaseProvider oldWidget) =>
      database != oldWidget.database;
}
