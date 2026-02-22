import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:boltuix/widgets/m_typography.dart';

class NavRailDemo extends StatefulWidget {
  const NavRailDemo({super.key}); // Constructor of the widget.

  @override
  State<NavRailDemo> createState() => _NavRailDemoState();
}

class _NavRailDemoState extends State<NavRailDemo> with RestorationMixin {
  final RestorableInt _selectedIndex = RestorableInt(
      0); // A RestorableInt variable to hold the current index of the selected navigation item.

  @override
  String get restorationId =>
      'nav_rail_demo'; // A unique restoration ID for the widget.

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex,
        'selected_index'); // Register the RestorableInt variable to be restored later.
  }

  @override
  void dispose() {
    _selectedIndex
        .dispose(); // Dispose the RestorableInt variable when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    const destinationFirst =
        'Get Started'; // A constant string to hold the name of the first navigation item.
    const destinationSecond =
        'Develop'; // A constant string to hold the name of the second navigation item.
    const destinationThird =
        'Tools'; // A constant string to hold the name of the third navigation item.
    const destinationForth =
        'Styles'; // A constant string to hold the name of the third navigation item.
   /* final selectedItem = <String>[
      // A list of strings to hold the name of all navigation items.
      destinationFirst,
      destinationSecond,
      destinationThird,
      destinationForth,
    ];*/
    return Scaffold(
      /*  appBar: AppBar(
        title: const Text(
          'Navigation Rail', // The title of the app bar.
        ),
      ),*/
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Color(0xfff3f6fc),
            // Next Navigation
            leading: Hero(
              tag: 'material_logo_hero_tag', // Same tag as the first widget
              child: LottieBuilder.asset(
                'assets/anim/material_logo.json',
                height: 70,
                fit: BoxFit.cover,
                repeat: false,
              ),
            ),

            selectedIndex: _selectedIndex.value,
            // The index of the currently selected navigation item.
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex.value =
                    index; // Update the index of the selected navigation item when a new item is selected.
              });
            },
            labelType: NavigationRailLabelType.selected,
            // The type of label to show for the selected navigation item.
            destinations: [
              NavigationRailDestination(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 45.0, bottom: 16.0),
                icon: Badge(
                    child: Icon(
                  Icons.home_sharp,
                  size: 30,
                )),
                /*   icon: Icon(
                  Icons.code,
                  size: 30,
                ),*/
                selectedIcon: Badge(
                    child: Icon(
                  Icons.home_rounded,
                  size: 40,
                )),
                /*selectedIcon: Icon(
                  Icons.code_rounded,
                  size: 30,
                ),*/
                label: Text(
                  destinationFirst, // The label of the first navigation item.
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.all(16.0),
                icon: Icon(
                  Icons.code,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.code,
                  size: 40,
                ),
                label: Text(
                  destinationSecond, // The label of the second navigation item.
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.all(16.0),
                icon: Icon(
                  Icons.mobile_friendly,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.mobile_friendly_rounded,
                  size: 40,
                ),
                label: Text(
                  destinationSecond, // The label of the second navigation item.
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.all(16.0),
                icon: Icon(
                  Icons.collections_bookmark_outlined,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.collections_bookmark_rounded,
                  size: 40,
                ),
                label: Text(
                  destinationThird, // The label of the third navigation item.
                ),
              ),
              NavigationRailDestination(
                padding: EdgeInsets.all(16.0),
                icon: Icon(
                  Icons.settings_suggest_outlined,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.settings_suggest_rounded,
                  size: 40,
                ),
                label: Text(
                  destinationForth, // The label of the third navigation item.
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // A vertical divider to separate the navigation rail from the main content.

          Expanded(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 16.0),
                  // Adjust the top padding to 10.0
                  child: TextStyleExample(
                    name: "Components",
                    //align: TextAlign.left,
                    style: textTheme.displaySmall!.copyWith(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextStyleExample(
                      name:
                          "Components are interactive building blocks for creating a user interface. They can be organized into categories based on their purpose: Action, containment, communication, navigation, selection, and text input.",
                      align: TextAlign.center,
                      style: textTheme.bodyMedium!),
                ),
                LottieBuilder.asset(
                  'assets/anim/line_blue.json',
                  fit: BoxFit.fitHeight,
                  height: 50,
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
