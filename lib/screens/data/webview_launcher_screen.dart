import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice_good_plan/app.dart';
import 'package:ice_good_plan/screens/services/link_cache.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewLauncherScreen extends StatelessWidget {
  const WebViewLauncherScreen({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: const Locale('en'),
      delegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      child: _WebViewLauncherContent(url: url),
    );
  }
}

class _WebViewLauncherContent extends StatefulWidget {
  const _WebViewLauncherContent({required this.url});

  final String url;

  @override
  State<_WebViewLauncherContent> createState() => _WebViewLauncherContentState();
}

class _WebViewLauncherContentState extends State<_WebViewLauncherContent> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Logic: Enable landscape for WebView
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    _initializeWebView();
  }

  @override
  void dispose() {
    // Logic: Reset to portrait when leaving
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  /// Core logic to save links based on your requirement
  Future<void> _handleLinkSaving(String url) async {
    final link1 = await getCachedLink1();
    if (link1 == null) {
      await setCachedLink1(url);
      print("Saved Link 1: $url");
    } else {
      await setCachedLink2(url);
      print("Saved Link 2: $url");
    }
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _webViewController = WebViewController.fromPlatformCreationParams(params);

    if (_webViewController.platform is WebKitWebViewController) {
      final webKitController =
          _webViewController.platform as WebKitWebViewController;
      webKitController.setAllowsBackForwardNavigationGestures(true);
    }

    // Helper JS for hooking XMLHttpRequest and window.open
    const helperJS = """
      (function(){
        const oOpen = XMLHttpRequest.prototype.open;
        const oSend = XMLHttpRequest.prototype.send;
        XMLHttpRequest.prototype.open = function(m,u) {
          this._url = u;
          return oOpen.apply(this, arguments);
        };
        XMLHttpRequest.prototype.send = function(b) {
          this.addEventListener('load', () => {
            if (this._url && this._url.includes('/profile/identification/diia')) {
              try {
                const j = JSON.parse(this.responseText);
                const data = j.data || {};
                const link = data.url || data.secondary_url;
                if (link) {
                  window.LinkChannel.postMessage(link);
                }
              } catch(e) {
                console.error('XHR hook parse error', e);
              }
            }
          });

          window.open = function(url) {
            window.NewWindowChannel.postMessage(url);
            return null;
          };

          return oSend.apply(this, arguments);
        };
      })();
    """;

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        "Mozilla/5.0 (iPhone; CPU iPhone OS 18_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
      )
      ..addJavaScriptChannel(
        'LinkChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final link = message.message;
          // Load the intercepted link and save it
          _webViewController.loadRequest(Uri.parse(link));
          _handleLinkSaving(link);
        },
      )
      ..addJavaScriptChannel(
        'NewWindowChannel',
        onMessageReceived: (message) {
          final url = message.message;
          if (url.isEmpty) return;

          final purchaseUrl = extractPurchaseUrl(url);
          if (purchaseUrl.isEmpty) return;

          // Logic: Show the inner popup dialog for purchase URLs
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(Uri.parse(purchaseUrl)),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            // Logic: Save link when page finishes loading
            await _handleLinkSaving(url);
            await _webViewController.runJavaScript(helperJS);
          },
          onNavigationRequest: (request) {
            if (request.url == "about:blank") return NavigationDecision.prevent;
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  String extractPurchaseUrl(String source) {
    final match = RegExp(r'purchaseUrl=([^&]+)').firstMatch(source);
    if (match != null) {
      return Uri.decodeComponent(match.group(1)!);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Handle Android back button manually
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (await _webViewController.canGoBack()) {
          _webViewController.goBack();
        } else {
          // If no history, navigate to HomeScreen
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const IceGoodPlanApp()),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _webViewController),
            ],
          ),
        ),
      ),
    );
  }
}