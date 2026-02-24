import 'package:shared_preferences/shared_preferences.dart';

const _keyLink1 = 'gamble_link1';
const _keyLink2 = 'gamble_link2';

/// Кеш ссылок: Link1 — первый URL, загрузившийся в WebView; Link2 — URL после редиректа.
/// При следующих запусках открываем Link2 (при отсутствии — Link1, затем ссылка с сервера).
/// При firstLink=true с сервера кеш очищаем и снова накапливаем Link1 → Link2.
Future<void> clearLinkCache() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_keyLink1);
  await prefs.remove(_keyLink2);
}

Future<String?> getCachedLink1() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_keyLink1);
}

Future<String?> getCachedLink2() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_keyLink2);
}

Future<void> setCachedLink1(String url) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_keyLink1, url);
}

Future<void> setCachedLink2(String url) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_keyLink2, url);
}
