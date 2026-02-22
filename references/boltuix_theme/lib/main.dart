import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:boltuix/screens/about/about_app.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/main_screen.dart';
import 'data/img.dart';
import 'data/my_colors.dart';
import 'm_widget_gallery_screen.dart';
import 'widgets/my_text.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

/*  if (!kReleaseMode) {
    // App is running in debug mode
    debugPrint('App is running in debug mode. Exiting...');
    if (Platform.isAndroid || Platform.isIOS) {
      SystemNavigator.pop(); // Close the app on Android and iOS
    } else {
      exit(0); // Close the app on other platforms
    }
  }*/

  try {
    // Check if app is installed from Play Store
    bool isFromPlayStore = await checkPlayStoreInstallation();
    if (isFromPlayStore) {
      debugPrint('App is not installed from Play Store. Exiting...');
      if (Platform.isAndroid || Platform.isIOS) {
        SystemNavigator.pop(); // Close the app on Android and iOS
      } else {
        exit(0); // Close the app on other platforms
      }
    }
  } catch (e) {
    debugPrint('Error checking Play Store installation: $e');
  }

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: MyColors.primary,
        onPrimary: Colors.white,
        secondary: MyColors.accent,
        onSecondary: Colors.white,
        primaryContainer: MyColors.primaryLight,
        secondaryContainer: MyColors.accentLight,
        surface: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      ),
      fontFamily: 'Jost',
      textTheme: TextTheme(
        displayLarge: TextStyle(letterSpacing: 1.0),
        displayMedium: TextStyle(letterSpacing: 1.0),
        displaySmall: TextStyle(letterSpacing: 1.0),
        headlineLarge: TextStyle(letterSpacing: 1.0),
        headlineMedium: TextStyle(letterSpacing: 1.0),
        headlineSmall: TextStyle(letterSpacing: 1.0),
        titleLarge: TextStyle(letterSpacing: 1.0),
        titleMedium: TextStyle(letterSpacing: 1.0),
        titleSmall: TextStyle(letterSpacing: 1.0),
        bodyLarge: TextStyle(letterSpacing: 1.0),
        bodyMedium: TextStyle(letterSpacing: 1.0),
        bodySmall: TextStyle(letterSpacing: 1.0),
        labelLarge: TextStyle(letterSpacing: 1.0),
        labelMedium: TextStyle(letterSpacing: 1.0),
        labelSmall: TextStyle(letterSpacing: 1.0),
      ),
      useMaterial3: true,
    ),
    // home: SplashScreen(),
    home: MainScreen(),
    //  home: MenuRoute(),
    routes: <String, WidgetBuilder>{
      //  '/MenuRoute': (BuildContext context) => MainScreen(),
      '/About': (BuildContext context) => AboutApp(),
      '/WidgetGallery': (BuildContext context) => WidgetGallery(),
    },
  ));
}

Future<bool> checkPlayStoreInstallation() async {
  try {
    if (Platform.isAndroid) {
     // final packageInfo = await PackageInfo.fromPlatform();
      final installer = await MethodChannel('package_info_plus')
          .invokeMethod<String>('getInstallerPackageName');

      debugPrint('Installer Package: $installer');

      // Check if the installer is Play Store
      return installer == 'com.android.vending';
    }
    return true; // Assume true for non-Android platforms
  } catch (e) {
    debugPrint('Error checking Play Store installation: $e');
    return false;
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/MenuRoute');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 120, // Increased width
          height: 180, // Increased height
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                child: Image.asset(
                  Img.get('logo.png'),
                  color: Colors.grey[800],
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10), // Used SizedBox for spacing
              Text(
                "BOLT UIX",
                style: MyText.headline(context)!.copyWith(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Paid Ver 1.2025.1",
                style: MyText.body1(context)!.copyWith(
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: 20), // Used SizedBox for spacing
              Container(
                height: 5,
                width: 80,
                child: LinearProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(MyColors.primaryLight),
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
