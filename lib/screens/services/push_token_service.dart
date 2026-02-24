import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _channel = MethodChannel('app.push_token');

/// Пуш-токен без Firebase: на iOS — APNS через нативный канал, на Android — нет.
Future<String> getPushToken() async {
  if (Platform.isIOS) {
    try {
      // Даём время на запрос разрешения и регистрацию
      await Future.delayed(const Duration(milliseconds: 800));
      String? token = await _channel.invokeMethod('getPushToken') as String?;
      if (token == null || token.isEmpty) {
        await Future.delayed(const Duration(seconds: 2));
        token = await _channel.invokeMethod('getPushToken') as String?;
      }
      if (token == null || token.isEmpty) {
        await Future.delayed(const Duration(seconds: 3));
        token = await _channel.invokeMethod('getPushToken') as String?;
      }
      if (token != null && token.isNotEmpty) {
        if (kDebugMode) {
          print('[PushToken] APNS token (length ${token.length}): $token');
        }
        return token;
      }
      final reason = await _channel.invokeMethod('getPushTokenError') as String?;
      if (kDebugMode && reason != null && reason.isNotEmpty) {
        print('[PushToken] Не получен. Причина: $reason');
        print('[PushToken] Проверь: реальное устройство (не симулятор), Xcode → Capabilities → Push Notifications.');
      }
    } catch (e) {
      if (kDebugMode) print('[PushToken] $e → no_apns_token');
    }
  }
  if (kDebugMode) print('[PushToken] no_apns_token');
  return 'no_apns_token';
}
