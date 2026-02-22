import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:boltuix/app/dinosaur/constants.dart';
import 'package:boltuix/app/dinosaur/data_set_dinosaur.dart';
import 'package:boltuix/app/dinosaur/details_view.dart';
import 'package:palette_generator/palette_generator.dart'; // 🎨 Import for extracting colors

class AnimatingScreen extends StatefulWidget {
  const AnimatingScreen({super.key});

  @override
  State<AnimatingScreen> createState() => _AnimatingScreenState();
}

class _AnimatingScreenState extends State<AnimatingScreen> {
  // 🖌️ Store heading colors for each card
  List<Color> headingColors = [];

  @override
  void initState() {
    super.initState();
    _generateHeadingColors(); // 🎨 Generate colors when widget initializes
  }

  Future<void> _generateHeadingColors() async {
    // 🎨 Extract dominant colors for all images
    List<Color> colors = [];
    for (var planet in planets) {
      final palette = await PaletteGenerator.fromImageProvider(
        AssetImage(planet.iconImage.toString()), // 🖼 Planet image
      );
      colors.add(
          palette.dominantColor?.color ?? Colors.black); // Default to black
    }
    setState(() {
      headingColors = colors; // 🎨 Save the extracted colors
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor, // 🌈 Background gradient end color
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientStartColor,
              gradientEndColor
            ], // 🌈 Gradient colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 📝 Heading Section
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: <Widget>[
                      const Row(
                        children: [
                          Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 40,
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Text(
                            'to dinosaur world...',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0x7cdbf1ff),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 🌀 Swiper Section
                SizedBox(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Swiper(
                      indicatorLayout: PageIndicatorLayout.COLOR,
                      autoplay: true, // 🔄 Auto-play cards
                      control: SwiperControl(), // 🎮 Swiper controls
                      itemCount: planets.length, // 🔢 Number of cards
                      itemWidth: MediaQuery.of(context).size.width * 0.8,
                      layout: SwiperLayout.STACK, // 🌀 Stack layout
                      viewportFraction: 0.8,
                      pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          activeSize: 20,
                          activeColor:
                              Colors.yellow.shade300, // 🌟 Active dot color
                          space: 5,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            // 📲 Navigate to DetailsView on tap
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (context, a, b) => DetailsView(
                                  planetInfo: planets[index],
                                ),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  return FadeTransition(
                                    opacity:
                                        animation, // ✨ Smooth fade transition
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  const SizedBox(
                                      height: 100), // 🖼 Spacer for image
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          32), // 🟠 Rounded card
                                    ),
                                    elevation: 8,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(
                                              height:
                                                  100), // Spacer for card content
                                          Text(
                                            planets[index].name.toString(),
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: headingColors.isNotEmpty
                                                  ? headingColors[
                                                      index] // 🎨 Dynamic heading color
                                                  : Colors.black,
                                              fontWeight: FontWeight.w900,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            "Dinosaur",
                                            style: TextStyle(
                                              fontSize: 23,
                                              color: primaryTextColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 32.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Know more",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: secondaryTextColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: secondaryTextColor,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Hero(
                                tag: planets[index]
                                    .position, // 🦸‍♂️ Hero animation
                                child: Image.asset(
                                  planets[index].iconImage.toString(),
                                  height: 300, // 🖼 Image height
                                  width: 200, // 🖼 Image width
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
