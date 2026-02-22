import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class SeekbarRange extends StatefulWidget {
  SeekbarRange();

  @override
  SeekbarRangeState createState() => new SeekbarRangeState();
}

class SeekbarRangeState extends State<SeekbarRange> {
  RangeValues _currentRangeValues1 = const RangeValues(20, 60);
  RangeValues _currentRangeValues2 = const RangeValues(5, 50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Range Seekbar")
          as PreferredSizeWidget?,
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Added padding around the body
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // First RangeSlider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Start: ${_currentRangeValues1.start.toInt()}",
                      style: MyText.body1(context)!
                          .copyWith(color: MyColors.grey_40),
                    ),
                    Spacer(),
                    Text(
                      "End: ${_currentRangeValues1.end.toInt()}",
                      style: MyText.body1(context)!
                          .copyWith(color: MyColors.grey_40),
                    ),
                  ],
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
                    ),
                  ),
                  child: RangeSlider(
                    values: _currentRangeValues1,
                    min: 0,
                    max: 100,
                    labels: RangeLabels(
                      _currentRangeValues1.start.round().toString(),
                      _currentRangeValues1.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues1 = values;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30), // Space between sliders
            // Second RangeSlider
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Start: ${_currentRangeValues2.start.toInt()}",
                      style: MyText.body1(context)!
                          .copyWith(color: MyColors.grey_40),
                    ),
                    Spacer(),
                    Text(
                      "End: ${_currentRangeValues2.end.toInt()}",
                      style: MyText.body1(context)!
                          .copyWith(color: MyColors.grey_40),
                    ),
                  ],
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
                    ),
                  ),
                  child: RangeSlider(
                    values: _currentRangeValues2,
                    min: 0,
                    max: 100,
                    labels: RangeLabels(
                      _currentRangeValues2.start.round().toString(),
                      _currentRangeValues2.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues2 = values;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
