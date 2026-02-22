import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'data.dart';
import 'details.dart';
import 'model_items.dart';

class Model extends StatefulWidget {
  final double padding; // 📏 Horizontal padding for the list
  final double spacing; // 📏 Spacing between items

  const Model({
    Key? key,
    required this.padding,
    required this.spacing,
  }) : super(key: key);

  @override
  State<Model> createState() =>
      _ModelState(); // 🎯 Create state for Model widget
}

class _ModelState extends State<Model> {
  late final ScrollController
      _scrollController; // 🎛️ Scroll controller for horizontal list
  late final double
      _indexFactor; // 📐 Factor for calculating offsets during scroll

  static const _imageWidth = 180.0; // 📏 Fixed image width
  double _imageOffset = 0.0; // 🔄 Tracks image offset for parallax effect


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceWidth = MediaQuery.of(context).size.width; // 📱 Calculate device width
      setState(() {
        _indexFactor = (widget.spacing + _imageWidth) / deviceWidth; // 🔄 Offset factor
        _imageOffset = -widget.padding / deviceWidth; // 🔄 Initial offset
      });
    });

    _scrollController = ScrollController(); // 🎛️ Initialize scroll controller
    _scrollController.addListener(() {
      setState(() {
        _imageOffset = ((_scrollController.offset - widget.padding) /
            MediaQuery.of(context).size.width); // 🔄 Update image offset
      });
    });
  }


  @override
  void dispose() {
    _scrollController.dispose(); // 🧹 Clean up the scroll controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240, // 📏 Fixed height for the list
      child: ListView.separated(
        physics:
            const BouncingScrollPhysics(), // 🔄 Add bounce effect to scrolling
        padding: EdgeInsets.symmetric(
            horizontal: widget.padding), // 📏 Horizontal padding
        controller: _scrollController, // 🎛️ Attach scroll controller
        scrollDirection: Axis.horizontal, // ➡️ Horizontal scrolling
        separatorBuilder: (_, __) =>
            SizedBox(width: widget.spacing), // 📏 Spacing between items
        itemCount: data.length, // 🔢 Number of items in the list
        itemBuilder: (_, index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Details(
                      index: index,
                      hero:
                          "${data[index]["city"]}$index")), // 🚀 Navigate to details page
            );
          },
          child: SizedBox(
            height: 240,
            width: 200, // 📏 Fixed width for each card
            child: Card(
              elevation: 3, // 🛠️ Shadow effect
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // 🎨 Rounded corners
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2, // 🖼️ Top section for the image
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10), // 📏 Image margins
                      child: ModelItems(
                          index: index,
                          imageWidth: _imageWidth,
                          imageOffset: _imageOffset,
                          indexFactor: _indexFactor,
                          hero:
                              "${data[index]["city"]}$index"), // 🎭 Hero animation
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment:
                          Alignment.centerLeft, // 📍 Align text to the left
                      width: double.infinity, // 🔄 Take full width
                      margin: const EdgeInsets.only(
                          left: 15, bottom: 10, right: 10), // 📏 Text margins
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // 📍 Align content to start
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly, // ⚖️ Space out items
                        children: [
                          Text(
                            data[index]["city"], // 🏙️ City name
                            style: const TextStyle(
                              color: kSecondaryColor,
                              fontSize: 22,
                              letterSpacing: 1.3, // 🔠 Letter spacing for style
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons
                                    .locationDot, // 📍 Location icon
                                color: kSecondaryColor.withOpacity(0.5),
                                size: 18,
                              ),
                              const SizedBox(width: 2), // ⬅️ Small spacing
                              Text(
                                data[index][
                                    "city"], // 🏙️ City name again for location
                                style: TextStyle(
                                  color: kSecondaryColor.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
