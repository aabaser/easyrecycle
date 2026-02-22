import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';

import 'data.dart';

class Details extends StatefulWidget {
  final int index; // 🏷️ Index of the selected item
  final String hero; // 🎭 Hero animation tag
  const Details({Key? key, required this.index, required this.hero})
      : super(key: key);

  @override
  State<Details> createState() => DdetailsState(); // 🌟 State initialization
}

class DdetailsState extends State<Details> {
  final _controller = ScrollController(); // 🎛️ Scroll controller
  ScrollPhysics _physics =
      const ClampingScrollPhysics(); // 📜 Initial scroll physics
  bool appBarVAR = false; // 🚩 Toggle for showing app bar
  bool bottomBarImagesVAR = false; // 🚩 Toggle for showing bottom bar images

  Future run() async {
    // ⏳ Delay for animations
    await Future.delayed(const Duration(milliseconds: 350));
    setState(() {
      appBarVAR = true; // 🔄 Enable app bar animation
      bottomBarImagesVAR = true; // 🔄 Enable bottom bar animation
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      run(); // 🎬 Start animations
    } catch (e) {
      debugPrint("$e"); // 🛠️ Error handling
    }
    _controller.addListener(() {
      // 🕹️ Scroll behavior
      if (_controller.position.pixels <= 100) {
        setState(() => _physics =
            const ClampingScrollPhysics()); // 🔄 Change to clamping physics
      } else {
        setState(() => _physics =
            const BouncingScrollPhysics()); // 🔄 Change to bouncing physics
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width; // 📐 Screen width
    double displayHeight =
        MediaQuery.of(context).size.height; // 📐 Screen height
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // 🖱️ Vertical scroll
            controller: _controller, // 🎛️ Use scroll controller
            physics: _physics, // 📜 Apply dynamic physics
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40)), // 🎨 Rounded corners
                  elevation: 4, // 🛠️ Add shadow
                  child: Hero(
                    tag: widget.hero, // 🎭 Hero animation tag
                    child: Container(
                      height: displayHeight / 2, // 📐 Half screen height
                      width: displayWidth, // 📐 Full screen width
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight:
                                  Radius.circular(40)), // 🎨 Rounded corners
                          image: DecorationImage(
                              image: AssetImage(data[widget.index]["image"]),
                              fit: BoxFit.cover)), // 🖼️ Background image
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AnimatedCrossFade(
                            firstChild: Container(), // 🛠️ Placeholder
                            secondChild: appBar(), // 🎛️ Animated app bar
                            crossFadeState: appBarVAR
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst, // 🔄 Toggle app bar
                            duration: const Duration(
                                milliseconds: 400), // ⏳ Animation duration
                          ),
                          AnimatedCrossFade(
                            firstChild: Container(), // 🛠️ Placeholder
                            secondChild:
                                bottomBarImages(), // 🎛️ Animated bottom bar
                            crossFadeState: appBarVAR
                                ? CrossFadeState.showSecond
                                : CrossFadeState
                                    .showFirst, // 🔄 Toggle bottom bar
                            duration: const Duration(
                                milliseconds: 600), // ⏳ Animation duration
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15), // ⬆️ Spacing
                Container(
                  width: displayWidth,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20), // 📏 Padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // ⚖️ Space between items
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 📍 Align to start
                        children: [
                          Text(
                            data[widget.index]["city"], // 🏙️ City name
                            style: const TextStyle(
                              color: kSecondaryColor,
                              fontSize: 25,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5), // ⬆️ Small spacing
                          Text(
                            data[widget.index]["country"], // 🌍 Country name
                            style: const TextStyle(
                              color: kSecondaryColor,
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                            ),
                          )
                        ],
                      ),
                      const Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end, // 📍 Align to end
                        children: [
                          Text(
                            "\$20", // 💰 Price
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 24,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5), // ⬆️ Small spacing
                          Text(
                            "per person", // 💡 Additional price info
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black38.withOpacity(0.2), // 🎨 Light divider
                  endIndent: 20,
                  indent: 20,
                  height: 4,
                ),
                const SizedBox(height: 15), // ⬆️ Spacing
                const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xffeaeaea), // 🎨 Icon background
                    radius: 26,
                    child: Icon(
                      FontAwesomeIcons.locationDot, // 📍 Location icon
                      color: kSecondaryColor,
                    ),
                  ),
                  title: Text(
                    "Pizza del Colosseum 1, Rome", // 📍 Location details
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                ListTile(
                  isThreeLine: false, // 🖊️ Single line of text
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xffeaeaea),
                    radius: 26,
                    child: Icon(
                      Ionicons.time_outline, // ⏰ Time icon
                      color: kSecondaryColor,
                    ),
                  ),
                  title: Text(
                    "OPEN", // 🔓 Status
                    style: TextStyle(
                      color: kSecondaryColor.withOpacity(0.4),
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  subtitle: const Text(
                    "09.00 AM", // 🕘 Opening time
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  trailing: const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Show Details", // 🔗 Action link
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200, // 📏 Fixed height
                  width: displayWidth, // 📐 Full screen width
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20), // 📏 Padding
                  decoration: const BoxDecoration(
                      color: Colors.white, // 🎨 Map background
                      borderRadius: BorderRadius.all(
                          Radius.circular(14)), // 🎨 Rounded corners
                      image: DecorationImage(
                          image: AssetImage("assets/app_travel/map.jpg"),
                          fit: BoxFit.cover)), // 🗺️ Map image
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget appBar() {
    return Row(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(), // 🔙 Go back
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32), // 🎨 Rounded button
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.white, // 🎨 Button background
                  child: const Icon(
                    Ionicons.arrow_back_outline, // 🔙 Back icon
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32), // 🎨 Rounded button
              child: Container(
                width: 48,
                height: 48,
                color: Colors.white,
                child: const Icon(
                  Ionicons.download_outline, // 📥 Download icon
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: 48,
                height: 48,
                color: Colors.white,
                child: const Icon(
                  FontAwesomeIcons.heart, // ❤️ Favorite icon
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomBarImages() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24), // 🎨 Rounded bar
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // 🌫️ Blur effect
            child: Container(
              height: 90, // 📏 Fixed height
              color: kSecondaryColor
                  .withOpacity(0.25), // 🎨 Semi-transparent background
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    ...List.generate(
                        data.length,
                        (index) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      24), // 🎨 Rounded corners
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(24)),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    data[index]["image"]),
                                                fit:
                                                    BoxFit.cover)), // 🖼️ Image
                                      ),
                                      index == (data.length - 1)
                                          ? Container(
                                              color: Colors.blue.shade800
                                                  .withOpacity(
                                                      0.4), // 🎨 Overlay for last item
                                              child: const Center(
                                                child: Text(
                                                  "+5", // 🔢 More images
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
