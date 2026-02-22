import 'package:flutter/material.dart';
import 'package:boltuix/m_material_components.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'widgets/m_navigation_utils.dart';
import 'widgets/m_strings.dart';
import 'widgets/m_helper.dart';

class DetailPage extends StatefulWidget {
  final CustomComponent displayedItem; // Define displayedItem property

  const DetailPage({super.key, required this.displayedItem});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Uri _url = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLSfnwQbYqUwDfeTLH9e0VFYvmla4qyRohHePiUIs1eyiv91hag/viewform');

  late WebViewXController webviewController;
  final scrollController = ScrollController();

  Size get screenSize => MediaQuery.of(context).size;

  final initialContent = ' <h4>&nbsp;&nbsp;&nbsp;Loading... <h4>';

  @override
  void dispose() {
    webviewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Register WebView element with platform view registry
    /*ui_web.platformViewRegistry.registerViewFactory(
      'webview-type',
          (int viewId) => _buildWebViewX(),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
        appBar: AppBar(
          leading: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Color(0xFF0072ff), // Start color
                Color(0xFF00c6ff), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: IconButton(
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                NavigationUtil().finish(context);
              },
            ),
          ),
          title: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Color(0xFF0072ff), // Start color
                Color(0xFF00c6ff), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Text(
              widget.displayedItem.title,
              style: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          actions: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color(0xFFFD4685),
                  Color(0xFF6A88E5),
                  Color(0xFFFD4685),
                  Color(0xFFFE5A87),
                  Color(0xFFFE7689),
                  Color(0xFFFE5A87),
                  Color(0xFFFD4685)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: IconButton(
                tooltip: Strings.feedback,
                icon: const Icon(Icons.feedback_rounded),
                onPressed: _launchUrl,
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  Color(0xFFFD4685),
                  Color(0xFF6A88E5),
                  Color(0xFFFD4685),
                  Color(0xFFFE5A87),
                  Color(0xFFFE7689),
                  Color(0xFFFE5A87),
                  Color(0xFFFD4685)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: IconButton(
                tooltip: Strings.share,
                icon: const Icon(Icons.share_rounded),
                onPressed: () {
                  Share.share(
                      'Check out this Flutter template\'s Material 3 Design Kit: ${widget.displayedItem.website}',
                      subject: widget.displayedItem.title);
                },
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
        ),
        body: Stack(children: [
          Opacity(
            // opacity: 0.3, // Set opacity value between 0.0 and 1.0
            opacity: 1.0, // Set opacity value between 0.0 and 1.0
            child: Container(
              color: const Color(0xffE9F2F9),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Hero(
                tag: 'card_${widget.displayedItem.id}',
                // Unique tag for the Hero animation
                child: Card(
                    surfaceTintColor: Colors.white,
                    color: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.blue.shade100,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(45),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    //child: Text(' ${widget.displayedItem.id} HIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHIHI')//_buildWebViewX()
                    child: _buildWebViewX()),
              ),
            ),
          ),
        ]));
  }

  Widget _buildWebViewX() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: initialContent,
      initialSourceType: SourceType.html,
      height: screenSize.height,
      width: screenSize.width,
      /*   height: screenSize.height / 2,
      width: min(screenSize.width * 0.8, 1024),*/
      //  onWebViewCreated: (controller) => webviewController = controller,
      onWebViewCreated: (controller) {
        webviewController = controller;
        // Load the default URL when the web view is created
        webviewController.loadContent(
          widget.displayedItem.website,
          //'https://dartpad.dev/embed-flutter.html?&split=65&run=true&id=9f5115b63daed9ef96809c3b48bc605f',
        );
      },
      onPageStarted: (src) =>
          debugPrint('A new page has started loading: $src\n'),
      onPageFinished: (src) =>
          debugPrint('The page has finished loading: $src\n'),
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
              "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },
      dartCallBacks: {
        DartCallback(
          name: 'TestDartCallback',
          callBack: (msg) => showSnackBar(msg.toString(), context),
        )
      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
      navigationDelegate: (navigation) {
        debugPrint(navigation.content.sourceType.toString());
        return NavigationDecision.navigate;
      },
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
