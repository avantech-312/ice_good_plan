import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ice_good_plan/app_root.dart';
import 'package:ice_good_plan/database/app_database.dart';
import 'package:ice_good_plan/database/database_provider.dart';
import 'package:ice_good_plan/screens/data/webview_launcher_screen.dart';
import 'package:ice_good_plan/screens/services/appsflyer_service.dart';
import 'package:ice_good_plan/screens/services/link_cache.dart';
import 'package:ice_good_plan/screens/services/push_token_service.dart';
import 'package:ice_good_plan/screens/services/server_link_service.dart';
import 'package:ice_good_plan/theme/app_theme.dart';

class IceGoodPlanApp extends StatefulWidget {
  const IceGoodPlanApp({super.key});

  @override
  State<IceGoodPlanApp> createState() => _IceGoodPlanAppState();
}

class _IceGoodPlanAppState extends State<IceGoodPlanApp> {
  String? _urlToOpen;
  bool _initializing = true;
  late final AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
     _runInitializationLogic();
  }

    Future<void> _runInitializationLogic() async {
    AppsflyerService.init(appId: '6759394139');
    final asLng = Platform.localeName.split('_').first;
    final pushToken = await getPushToken();

    final linkResponse = await getLinkFromServer(
      asLng: asLng,
      asTok: pushToken,
    );

    String? urlToOpen;
    if (linkResponse != null) {
      if (linkResponse.firstLink) {
        await clearLinkCache();
        urlToOpen = linkResponse.link;
        if (kDebugMode) {
          print(
            '[Open] firstLink=true → забываем Link1/Link2, открываем с сервера: ${linkResponse.link}, naming: ${linkResponse.naming}',
          );
        }
      } else {
        final cachedLink2 = await getCachedLink2();
        final cachedLink1 = await getCachedLink1();
        urlToOpen = (cachedLink2 != null && cachedLink2.isNotEmpty)
            ? cachedLink2
            : (cachedLink1 != null && cachedLink1.isNotEmpty)
            ? cachedLink1
            : linkResponse.link;
        if (kDebugMode) {
          if (cachedLink2 != null && cachedLink2.isNotEmpty) {
            print(
              '[Open] firstLink=false → открываем из кеша Link2: $cachedLink2',
            );
          } else if (cachedLink1 != null && cachedLink1.isNotEmpty) {
            print(
              '[Open] firstLink=false → открываем из кеша Link1: $cachedLink1',
            );
          } else {
            print(
              '[Open] firstLink=false, кеш пуст → открываем ссылку с сервера: ${linkResponse.link}, naming: ${linkResponse.naming}',
            );
          }
        }
      }
    } else {
      final cachedLink2 = await getCachedLink2();
      final cachedLink1 = await getCachedLink1();
      urlToOpen = (cachedLink2 != null && cachedLink2.isNotEmpty)
          ? cachedLink2
          : (cachedLink1 != null && cachedLink1.isNotEmpty)
          ? cachedLink1
          : null;
      if (kDebugMode && urlToOpen != null) {
        print('[Open] Ответа нет → открываем из кеша: $urlToOpen');
      }
    }

    // Update state to close the loader and pass the URL
    if (mounted) {
      setState(() {
        _urlToOpen = urlToOpen;
        _initializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DatabaseProvider(
      database: _database,
      child: CupertinoApp(
        title: 'Ice Good Plan',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: _buildHome()
      ),
    );
  }

  Widget _buildHome() {
    // 1. Show fullscreen white loader while logic is running
    if (_initializing) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }

    // 2. Once ready, show Launcher or AppRoot (original logic)
    if (_urlToOpen != null && _urlToOpen!.isNotEmpty) {
      return WebViewLauncherScreen(url: _urlToOpen!);
    } else {
      return const IceGoodPlanAppRoot();
    }
  }
}
