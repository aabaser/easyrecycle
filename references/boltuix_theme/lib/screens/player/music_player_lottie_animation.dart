import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:lottie/lottie.dart';
import 'package:palette_generator/palette_generator.dart';

class MusicPlayerLottieAnimation extends StatefulWidget {
  @override
  MusicPlayerLottieAnimationState createState() =>
      MusicPlayerLottieAnimationState();
}

class MusicPlayerLottieAnimationState
    extends State<MusicPlayerLottieAnimation> {
  double value1 = 0.3;
  void setValue1(double value) => setState(() => value1 = value);

  Color dominantColor = Colors.pinkAccent; // Default color
  Color darkVariantColor = Colors.pink; // Default dark variant color
  Color lightVariantColor =
      Colors.pinkAccent.shade100; // Default light variant color

  @override
  void initState() {
    super.initState();
    _updatePalette();
  }

  Future<void> _updatePalette() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      AssetImage(Img.get("project-5.jpg")),
    );
    setState(() {
      /*dominantColor = paletteGenerator.lightVibrantColor?.color ?? Colors.pinkAccent;
      darkVariantColor = paletteGenerator.darkVibrantColor?.color ?? Colors.pink;
      lightVariantColor = paletteGenerator.lightVibrantColor?.color ?? Colors.pinkAccent.shade100;*/
      dominantColor =
          paletteGenerator.darkMutedColor?.color ?? Colors.pinkAccent;
      darkVariantColor = paletteGenerator.darkMutedColor?.color ?? Colors.pink;
      lightVariantColor = paletteGenerator.darkVibrantColor?.color ??
          Colors.pinkAccent.shade100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.1, // Set opacity to 10%
            child: Lottie.asset(
              'assets/images/lottie_music.json',
              fit: BoxFit.cover,
              repeat: true,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    const ['**'], // Targets all elements in the Lottie file
                    value: dominantColor, // Dominant color from the image
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarBrightness: Brightness.dark,
                ),
                title: Text(
                  "Now Playing",
                  style:
                      MyText.title(context)!.copyWith(color: darkVariantColor),
                ),
                leading: IconButton(
                  icon: Icon(Icons.menu_rounded, color: lightVariantColor),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.settings, color: lightVariantColor),
                    onPressed: () {},
                  ),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 126,
                backgroundColor: MyColors.grey_20,
                child: CircleAvatar(
                  radius: 123,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: AssetImage(Img.get("b_image_7.png")),
                  ),
                ),
              ),
              Container(height: 20),
              Text(
                "Locking Up Your Symptoms",
                style: MyText.title(context)!.copyWith(
                    color: darkVariantColor, fontWeight: FontWeight.w400),
              ),
              Container(height: 5),
              Text(
                "Who He Should Be",
                style:
                    MyText.subhead(context)!.copyWith(color: MyColors.grey_40),
              ),
              Container(height: 20),
              Container(
                height: 100,
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.skip_previous, color: lightVariantColor),
                      onPressed: () {},
                    ),
                    Container(width: 20),
                    FloatingActionButton(
                      child: Icon(Icons.play_arrow, color: Colors.white),
                      mini: false,
                      elevation: 2,
                      backgroundColor: darkVariantColor,
                      onPressed: () {},
                    ),
                    Container(width: 20),
                    IconButton(
                      icon: Icon(Icons.skip_next, color: lightVariantColor),
                      onPressed: () {},
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
