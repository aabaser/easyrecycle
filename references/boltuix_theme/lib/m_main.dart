import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:boltuix/m_empty_state.dart';
import 'm_widget_gallery_screen.dart';
import 'widgets/navigation_rail_demo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    print("No internet connection");
  }

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Route<dynamic> _unknownRouteHandler(RouteSettings settings) {
      return MaterialPageRoute(
        builder: (context) => EmptyStateScreen(),
      );
    }

    Route<dynamic> generateRoute(RouteSettings settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => const WidgetGallery());
        case '/screen1':
          return MaterialPageRoute(builder: (context) => const WidgetGallery());
        default:
          return _unknownRouteHandler(settings);
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: generateRoute,
      onUnknownRoute: _unknownRouteHandler,
      builder: (BuildContext context, Widget? child) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return EmptyStateScreen();
        };
        return child!;
      },
      theme: ThemeData(
        colorSchemeSeed: Colors.blue.shade900, //Color(0xFF6565FF)
      ),
      home: const Scaffold(
        //  body: MyWidget(),
        //   body: FlutterGallery(),
        body: NavRailDemo(),
      ),
    );
  }
}
