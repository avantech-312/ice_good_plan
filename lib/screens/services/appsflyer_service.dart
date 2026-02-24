import 'dart:async';
import 'dart:convert'; // For jsonEncode/jsonDecode
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppsflyerService {
  static const String devKey = 'uFRoY7xAJhP3nB5vG7d3EY';
  static const String _storageKey = 'af_conversion_data';

  static AppsFlyerOptions? _options;
  static AppsflyerSdk? _instance;

  // Completer to bridge the gap between init listener and getConversionData
  static final Completer<Map<String, dynamic>> _conversionCompleter =
      Completer();

  static AppsflyerSdk init({
    String? devKey,
    required String appId,
    bool showDebug = false,
  }) {
    final key = devKey ?? AppsflyerService.devKey;
    _options = AppsFlyerOptions(
      afDevKey: key,
      appId: appId,
      showDebug: showDebug,
      disableAdvertisingIdentifier: true,
    );

    _instance = AppsflyerSdk(_options!);

    // 1. Setup Listener BEFORE initSdk
    _instance?.onInstallConversionData((res) {
      _handleConversionData(res);
    });

    // 2. Start SDK
    _instance?.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );

    return _instance!;
  }

  static AppsflyerSdk? get instance => _instance;

  static Future<String> getAppsFlyerUID() async {
    final uid = await _instance?.getAppsFlyerUID() ?? '';
    return uid.isEmpty ? '00000000-0000-0000-0000-000000000000' : uid;
  }

  /// Internal handler: Parses payload, ADDS defaults, and SAVES EVERYTHING to storage.
  static Future<void> _handleConversionData(dynamic res) async {
    try {
      // Safely cast the payload to a Map
      final dynamic rawPayload = res['payload'];
      
      if (rawPayload != null) {
        // Create a mutable copy of ALL data in the payload
        final data = Map<String, dynamic>.from(rawPayload);

        // Ensure essential fields exist, but preserve everything else from payload
        data['install_time'] =
            data['install_time'] ?? DateTime.now().toIso8601String();
        data['is_first_launch'] = data['is_first_launch'] ?? true;
        data['af_status'] = data['af_status'] ?? 'Organic';
        data['af_message'] = data['af_message'] ?? 'organic install';

        // 3. Save the FULL data map to Persistent Storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_storageKey, jsonEncode(data));

        // Complete the waiter if someone is waiting
        if (!_conversionCompleter.isCompleted) {
          _conversionCompleter.complete(data);
        }
      }
    } catch (e) {
      print("Error parsing conversion data: $e");
    }
  }

  /// Modified logic: Check Storage -> Check Completer -> Return Default
  static Future<Map<String, dynamic>> getConversionData() async {
    // 4. Check Persistent Storage first (for 2nd+ run)
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedString = prefs.getString(_storageKey);

      if (storedString != null && storedString.isNotEmpty) {
        // Returns the full saved map with all original payload fields
        return Map<String, dynamic>.from(jsonDecode(storedString));
      }
    } catch (_) {}

    // 5. Default fallback data
    final defaultData = <String, dynamic>{
      'install_time': DateTime.now().toIso8601String(),
      'af_message': 'organic install',
      'af_status': 'Organic',
      'is_first_launch': true,
    };

    // If completer is already done (init happened fast), return it
    if (_conversionCompleter.isCompleted) {
      return _conversionCompleter.future;
    }

    // 6. Wait for listener with 5 second timeout
    try {
      return await _conversionCompleter.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print("AF Timeout: returning default data");
          return defaultData;
        },
      );
    } catch (_) {
      return defaultData;
    }
  }

  /// Now returns the COMPLETE map, not just a filtered subset.
  static Future<Map<String, dynamic>> buildAsData() async {
    final conversion = await getConversionData();
    
    // CHANGE: Return the whole map. 
    // This ensures keys like 'campaign', 'media_source', etc. are passed through.
    return conversion;
  }
}