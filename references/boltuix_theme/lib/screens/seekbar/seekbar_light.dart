import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/circle_thumb_shape.dart';
import 'package:boltuix/widgets/toolbar.dart';

class SeekbarBasic extends StatefulWidget {
  SeekbarBasic();

  @override
  SeekbarBasicState createState() => new SeekbarBasicState();
}

class SeekbarBasicState extends State<SeekbarBasic> {
  double value1 = 0.7, value2 = 0.3, value3 = 66, value4 = 25;

  void setValue1(double value) => setState(() => value1 = value);
  void setValue2(double value) => setState(() => value2 = value);
  void setValue3(double value) => setState(() => value3 = value);
  void setValue4(double value) => setState(() => value4 = value);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Basic")
          as PreferredSizeWidget?,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Basic Slider 1",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SliderTheme(
                  data: SliderThemeData(
                      thumbColor: MyColors.accent,
                      trackHeight: 2,
                      trackShape: RectangularSliderTrackShape(),
                      activeTrackColor: MyColors.accent,
                      inactiveTrackColor: MyColors.grey_10,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      )),
                  child: Slider(
                    value: value1,
                    onChanged: setValue1,
                  ),
                ),
                SizedBox(height: 20), // Added spacing
                Text(
                  "Basic Slider 2",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SliderTheme(
                  data: SliderThemeData(
                      thumbColor: MyColors.primary,
                      trackHeight: 2,
                      trackShape: RectangularSliderTrackShape(),
                      activeTrackColor: MyColors.primary,
                      inactiveTrackColor: MyColors.grey_10,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      )),
                  child: Slider(
                    value: value2,
                    onChanged: setValue2,
                  ),
                ),
                SizedBox(height: 20), // Added spacing
                Text(
                  "Slider with Divisions 3",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: MyColors.accent,
                    trackHeight: 2,
                    trackShape: RectangularSliderTrackShape(),
                    activeTrackColor: MyColors.accent,
                    inactiveTrackColor: MyColors.grey_10,
                    thumbShape: CircleThumbShape(thumbRadius: 8),
                  ),
                  child: Slider(
                    value: value3,
                    onChanged: setValue3,
                    divisions: 3,
                    min: 0,
                    max: 100,
                  ),
                ),
                SizedBox(height: 20), // Added spacing
                Text(
                  "Slider with Divisions and Label 4",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: MyColors.primary,
                    trackHeight: 2,
                    trackShape: RectangularSliderTrackShape(),
                    activeTrackColor: MyColors.primary,
                    inactiveTrackColor: MyColors.grey_10,
                    thumbShape: CircleThumbShape(thumbRadius: 8),
                  ),
                  child: Slider(
                    value: value4,
                    onChanged: setValue4,
                    divisions: 4,
                    label: "$value4",
                    min: 0,
                    max: 100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
