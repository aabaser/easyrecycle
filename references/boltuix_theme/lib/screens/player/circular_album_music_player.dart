import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'dart:ui';
import 'package:palette_generator/palette_generator.dart';

class CircularAlbumMusicPlayer extends StatefulWidget {
  final String title;
  final String artist;
  final String albumImage;

  CircularAlbumMusicPlayer({
    required this.title,
    required this.artist,
    required this.albumImage,
  });

  @override
  CircularAlbumMusicPlayerState createState() =>
      new CircularAlbumMusicPlayerState();
}

class CircularAlbumMusicPlayerState extends State<CircularAlbumMusicPlayer>
    with SingleTickerProviderStateMixin {
  double value1 = 0.3;
  Color dominantColor = Colors.green;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _updatePalette();
    _controller = AnimationController(
      duration: const Duration(
          seconds: 60), // Duration of the rotation (slow rotation)
      vsync: this,
    )..repeat(); // Repeat the animation continuously
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setValue1(double value) => setState(() => value1 = value);

  Future<void> _updatePalette() async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      AssetImage(widget.albumImage),
    );
    setState(() {
      dominantColor = paletteGenerator.darkMutedColor?.color ?? Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.black)),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(widget.albumImage, fit: BoxFit.cover),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                    Colors.black,
                    Colors.black
                  ],
                ),
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
                  style: MyText.title(context)!.copyWith(color: Colors.white),
                ),
                leading: IconButton(
                  icon: Icon(Icons.menu_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search_rounded),
                    onPressed: () {},
                  ),
                ],
              ),
              Spacer(), // Pushes the rotating image to the center of the screen
              AnimatedBuilder(
                animation: _controller,
                child: CircleAvatar(
                  radius: 93,
                  backgroundColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage(widget.albumImage),
                  ),
                ),
                builder: (BuildContext context, Widget? child) {
                  return Transform.rotate(
                    angle: _controller.value * 2.0 * 3.141592653589793,
                    child: child,
                  );
                },
              ),
              Spacer(), // Pushes the rotating image to the center of the screen
              Text(
                widget.title,
                style: MyText.title(context)!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5),
              Text(
                widget.artist,
                style:
                    MyText.subhead(context)!.copyWith(color: MyColors.grey_40),
              ),
              Spacer(),
              MusicControls(
                currentTime: "0:00",
                totalTime: "3:00", // Dummy total time
                value: value1,
                onValueChanged: setValue1,
                dominantColor: dominantColor,
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class MusicControls extends StatelessWidget {
  final String currentTime;
  final String totalTime;
  final double value;
  final ValueChanged<double> onValueChanged;
  final Color dominantColor;

  MusicControls({
    required this.currentTime,
    required this.totalTime,
    required this.value,
    required this.onValueChanged,
    required this.dominantColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(currentTime,
                  style: TextStyle(fontSize: 14, color: MyColors.grey_60)),
              IconButton(
                icon:
                    Icon(Icons.skip_previous_rounded, color: MyColors.grey_40),
                onPressed: () {},
              ),
              FloatingActionButton(
                child: Icon(Icons.play_arrow, color: Colors.white),
                mini: false,
                elevation: 2,
                backgroundColor: dominantColor,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: MyColors.grey_40),
                onPressed: () {},
              ),
              Text(totalTime,
                  style: TextStyle(fontSize: 14, color: MyColors.grey_60)),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.repeat, color: MyColors.grey_40),
              onPressed: () {},
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: dominantColor,
                  trackHeight: 4,
                  activeTrackColor: dominantColor,
                  inactiveTrackColor: Colors.grey[200],
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                ),
                child: Slider(value: value, onChanged: onValueChanged),
              ),
            ),
            IconButton(
              icon: Icon(Icons.shuffle, color: MyColors.grey_40),
              onPressed: () {},
            ),
            SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
