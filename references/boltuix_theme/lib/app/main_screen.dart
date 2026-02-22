import 'package:flutter/material.dart';
import 'package:boltuix/app/pages/app_about.dart';
import 'package:boltuix/app/pages/dashboard_screen.dart';
import 'package:boltuix/app/pages/training_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'flutter_pro_uix_app_theme.dart';
import 'models/tabIcon_data.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FlutterBoltuixAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = DashboardScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FlutterBoltuixAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              // First item action
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      DashboardScreen(animationController: animationController);
                });
              });
            } else if (index == 1) {
              // Second item action
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      TrainingScreen(animationController: animationController);
                });
              });
            } else if (index == 2) {
              // Third item action
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = AppAboutScree();
                });
              });
            } else if (index == 3) {
              /*const String email = 'boltuix@gmail.com';
              const String subject = 'Hello from Flutter App';
              const String body = 'I wanted to reach out to you regarding...';
              final String mailtoUrl = 'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
*/
              animationController?.reverse().then<dynamic>((data) async {
                if (!mounted) {
                  return;
                }
                try {
                  // Check if the URL can be launched
                  // Launch the URL
                  await launchUrl(Uri.parse('https://www.youtube.com/channel/UCr6xjVwoyVkx7Q5AMEoUzhg?sub_confirmation=1'));
                } catch (e) {
                  // Show error message if an exception occurs
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error occurred: $e'),
                    ),
                  );
                }
              });
            }
          },
        ),
      ],
    );
  }
}
