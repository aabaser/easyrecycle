import 'package:flutter/material.dart';
import 'package:boltuix/app/dinosaur/constants.dart';
import 'package:boltuix/app/dinosaur/data_set_dinosaur.dart';
import 'package:palette_generator/palette_generator.dart'; // 🎨 Import for extracting colors

class DetailsView extends StatefulWidget {
  final DinosaurInfo? planetInfo;

  const DetailsView({super.key, this.planetInfo});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  Color dominantColor = Colors.black; // 🎨 Default color for the heading
  Color lightColor = Colors.grey
      .withOpacity(0.2); // 🌟 Default light color for position number

  late String iconImagePath; // 🖼 Extracted icon image path

  @override
  void initState() {
    super.initState();
    iconImagePath = widget.planetInfo!.iconImage
        .toString(); // 🖼 Assign image path to variable
    _updatePalette(); // 🎨 Extract the colors when the widget initializes
  }

  Future<void> _updatePalette() async {
    // 🎨 Extract colors from the image
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      AssetImage(iconImagePath), // 🖼 Use extracted image path
    );

    // Update dominant and light colors
    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;

      // Extract the lightest color for the position number
      lightColor = paletteGenerator.colors
              .where((color) =>
                  HSLColor.fromColor(color).lightness >
                  0.7) // 🌟 Very light colors
              .fold<Color?>(null, (previous, element) {
            if (previous == null) return element;
            return HSLColor.fromColor(element).lightness >
                    HSLColor.fromColor(previous).lightness
                ? element
                : previous;
          }) ??
          Colors.grey.withOpacity(0.2); // Default fallback
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 32),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 300, // 🖼 Spacer for the image
                  ),
                  Text(
                    widget.planetInfo!.name.toString(),
                    style: TextStyle(
                      fontSize: 35,
                      color: dominantColor, // 🎨 Dynamic heading color
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Dinosaur",
                    style: TextStyle(
                        fontSize: 20,
                        color: primaryTextColor, // ✏️ Sub-heading color
                        fontWeight: FontWeight.w300),
                    textAlign: TextAlign.left,
                  ),
                  const Divider(
                    color: Colors.black38, // ➗ Divider for section separation
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Text(
                        widget.planetInfo!.description.toString(),
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: contentTextColor, // 📜 Content text color
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 60, // 📝 Maximum lines for the description
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30, // 🔚 Spacer at the bottom
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              right: 5, // 📍 Position the image on the screen
              child: Hero(
                  tag: widget.planetInfo!.position, // 🦸‍♂️ Hero animation tag
                  child: Image.asset(
                    iconImagePath, // 🖼 Use the extracted image path
                    width: 300,
                  ))),
          Positioned(
              top: 60,
              left: 32,
              child: Text(
                widget.planetInfo!.position.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 247,
                    color: lightColor.withOpacity(
                        0.4)), // 🌟 Light color for position number
              )),
          IconButton(
              onPressed: () {
                Navigator.pop(context); // 🔙 Back button functionality
              },
              icon: const Icon(Icons.arrow_back_ios_new))
        ],
      )),
    );
  }
}
