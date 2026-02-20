import 'package:flutter/cupertino.dart';
import 'package:ice_good_plan/app_root.dart';
import 'package:ice_good_plan/database/app_database.dart';
import 'package:ice_good_plan/database/database_provider.dart';
import 'package:ice_good_plan/theme/app_theme.dart';

class IceGoodPlanApp extends StatefulWidget {
  const IceGoodPlanApp({super.key});

  @override
  State<IceGoodPlanApp> createState() => _IceGoodPlanAppState();
}

class _IceGoodPlanAppState extends State<IceGoodPlanApp> {
  late final AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return DatabaseProvider(
      database: _database,
      child: CupertinoApp(
        title: 'Ice Good Plan',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: const IceGoodPlanAppRoot(),
      ),
    );
  }
}
