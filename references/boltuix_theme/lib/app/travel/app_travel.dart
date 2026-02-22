import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'data.dart';
import 'model.dart';

class TravelHome extends StatefulWidget {
  const TravelHome({Key? key}) : super(key: key);

  @override
  State<TravelHome> createState() =>
      _HomeState(); // 🎯 Initializing the state for TravelHome
}

class _HomeState extends State<TravelHome> {
  static const _padding = 24.0; // 📏 Consistent padding value
  static const _spacing = 10.0; // 🛠️ Consistent spacing value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // 🖱️ Enable vertical scrolling
          physics:
              const BouncingScrollPhysics(), // 🔄 Add a bounce effect to scrolling
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch, // 🔍 Stretch to fill the screen width
            children: [
              const SizedBox(height: 24), // ⬆️ Add spacing
              header(), // 🛠️ Header widget with title and avatar
              const SizedBox(height: 24), // ⬆️ Add spacing
              searchBar(), // 🔎 Search bar for discovering places
              const SizedBox(height: 36), // ⬆️ Add spacing
              categories(), // 🌆 Categories section for exploring cities
              const SizedBox(height: 16), // ⬆️ Add spacing
              const Model(
                // 🏗️ Model widget
                padding: _padding,
                spacing: _spacing,
              ),
              const SizedBox(height: 20), // ⬆️ Add spacing
              modelCategories(), // 📋 Display additional categories
              const SizedBox(height: 36), // ⬆️ Add spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(
          horizontal: _padding), // 📏 Add consistent padding
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // ⚖️ Space between icons
        children: [
          Icon(
            FontAwesomeIcons.barsStaggered, // ☰ Menu icon
            color: kSecondaryColor,
            size: 24,
          ),
          Icon(
            FontAwesomeIcons.bell, // 🔔 Notification bell icon
            color: kSecondaryColor,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _padding), // 📏 Add consistent padding
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // ⚖️ Space out header content
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // 📍 Align text to the start
              children: [
                Text(
                  'Where do', // 🌍 Title part 1
                  style: TextStyle(
                    color: kSecondaryColor.withOpacity(0.6),
                    fontSize: 22,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 4), // ⬆️ Small spacing
                const Text(
                  'you want to go?', // 🌍 Title part 2
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            // 🖼️ Avatar with profile picture
            backgroundColor: kAvatarColor,
            radius: 26,
            backgroundImage: AssetImage("assets/images/image_005.png"),
          ),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: _padding), // 📏 Add consistent padding
      child: Container(
        height: 46, // 📐 Fixed height for the search bar
        padding: const EdgeInsets.symmetric(horizontal: 24), // 📏 Inner padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28), // 🔲 Rounded corners
          color: kSecondaryColor.withOpacity(0.1), // 🎨 Light background color
        ),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.magnifyingGlass, // 🔍 Search icon
              color: kSecondaryColor.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 5), // ⬅️ Small spacing
            Text(
              'Discover a places ', // 🌍 Placeholder text
              style: TextStyle(
                color: kSecondaryColor.withOpacity(0.5),
              ),
            ),
            const Spacer(), // ↔️ Space between elements
            Icon(
              FontAwesomeIcons.sliders, // 🎚️ Filter icon
              color: kSecondaryColor.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget categories() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // 📍 Align text and items to the start
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _padding), // 📏 Add consistent padding
          child: Text(
            'Explore Cities', // 🌆 Section title
            style: TextStyle(
              color: kSecondaryColor,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20), // ⬆️ Add spacing
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: _padding), // 📏 Add consistent padding
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // ➡️ Enable horizontal scrolling
            physics:
                const BouncingScrollPhysics(), // 🔄 Add a bounce effect to scrolling
            child: Row(
              children: [
                Column(
                  children: [
                    const Text(
                      'All', // 🌍 Category: All
                      style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2), // ⬆️ Small spacing
                    Container(
                      width: 10,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Colors.blue, // 🎨 Highlight for "All" category
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10), // ➡️ Spacing between categories
                for (final category in categoryList)
                  Container(
                    margin: const EdgeInsets.only(
                        right: 10), // ➡️ Add margin between items
                    child: Text(
                      category, // 🌍 Category name
                      style: TextStyle(
                        color: kSecondaryColor.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget modelCategories() {
    return SizedBox(
      width: double.infinity, // 🔄 Take full width
      height: 200, // 📏 Fixed height
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // 📍 Align text and items to the start
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: _padding), // 📏 Add consistent padding
            child: Text(
              'Categories', // 📋 Section title
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 18), // ⬆️ Add spacing
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10), // 📏 Add consistent padding
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // ➡️ Enable horizontal scrolling
              physics:
                  const BouncingScrollPhysics(), // 🔄 Add a bounce effect to scrolling
              child: Row(
                children: [
                  ...List.generate(
                    data_2.length,
                    (i) => Container(
                      margin: const EdgeInsets.only(
                          left: 35), // ➡️ Add margin between items
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                const Color(0xffeaeaea), // 🎨 Background color
                            radius: 26, // 📏 Circle size
                            backgroundImage: AssetImage(
                                data_2[i]["image"]), // 🖼️ Category image
                          ),
                          const SizedBox(height: 15), // ⬆️ Add spacing
                          Text(
                            data_2[i]["name"], // 🌍 Category name
                            style: TextStyle(
                              color: kSecondaryColor.withOpacity(0.8),
                              fontSize: 18,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
