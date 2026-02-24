import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class FullscreenWebViewDialog extends StatefulWidget {
  final String url;
  final void Function(String url) onPageFinished;

  const FullscreenWebViewDialog({
    super.key,
    required this.url,
    required this.onPageFinished,
  });

  @override
  State<FullscreenWebViewDialog> createState() => _FullscreenWebViewDialogState();
}

class _FullscreenWebViewDialogState extends State<FullscreenWebViewDialog> {
  late WebViewController _webViewController;

  static const _helperJS = r"""
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
          if (link && typeof LinkChannel !== 'undefined') {
            LinkChannel.postMessage(link);
          }
        } catch(e) {}
      }
    });
    return oSend.apply(this, arguments);
  };
  const origOpen = window.open;
  window.open = function(url) {
    if (typeof NewWindowChannel !== 'undefined') {
      try {
        NewWindowChannel.postMessage(typeof url === 'string' ? url : (url && url.href) ? url.href : String(url || ''));
      } catch(e) {}
    }
    return origOpen ? origOpen.apply(window, arguments) : null;
  };
})();
""";

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeWebView();
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
      (_webViewController.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (iPhone; CPU iPhone OS 18_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      )
      ..addJavaScriptChannel(
        'LinkChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final url = message.message;
          if (url.isNotEmpty) {
            _webViewController.loadRequest(Uri.parse(url));
            widget.onPageFinished(url);
          }
        },
      )
      ..addJavaScriptChannel(
        'NewWindowChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final url = message.message;
          if (url.isEmpty) return;
          final purchaseUrl = _extractPurchaseUrl(url);
          if (purchaseUrl.isEmpty) return;
          if (!mounted) return;
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
                        child: const Icon(Icons.close, color: Colors.white, size: 24),
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
          onPageFinished: (String url) async {
            widget.onPageFinished(url);
            await _webViewController.runJavaScript(_helperJS);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url == 'about:blank') {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  String _extractPurchaseUrl(String source) {
    final match = RegExp(r'purchaseUrl=([^&]+)').firstMatch(source);
    if (match != null) {
      return Uri.decodeComponent(match.group(1)!);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic res) async {
        if (didPop) return;
        final canGoBack = await _webViewController.canGoBack();
        if (canGoBack) {
          _webViewController.goBack();
        } else {
          if (mounted) Navigator.pop(context);
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }
}

void showFullscreenWebViewDialog(
  BuildContext context, {
  required String url,
  required void Function(String url) onPageFinished,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => FullscreenWebViewDialog(
      url: url,
      onPageFinished: onPageFinished,
    ),
  );
}
