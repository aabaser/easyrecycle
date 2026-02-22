import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class PickerTimeLight extends StatefulWidget {
  PickerTimeLight();

  @override
  PickerTimeLightState createState() => new PickerTimeLightState();
}

class PickerTimeLightState extends State<PickerTimeLight> {
  late Future<TimeOfDay?> selectedTime;
  String time = "-";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Time")
          as PreferredSizeWidget?,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text(
                  "Select a time from the picker below to see it displayed above.",
                  textAlign: TextAlign.center,
                  style: MyText.subhead(context)
                      ?.copyWith(color: Colors.grey[600]),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 45,
                color: Colors.grey[300],
                child: Text(
                  time,
                  style: MyText.title(context)?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MyColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  backgroundColor: MyColors.primary,
                ),
                child: Text(
                  "PICK TIME",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showDialogPicker(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDialogPicker(BuildContext context) {
    selectedTime = showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    selectedTime.then((value) {
      setState(() {
        if (value == null) return;
        final period = value.period == DayPeriod.am ? "AM" : "PM";
        final formattedHour = value.hourOfPeriod.toString().padLeft(2, '0');
        final formattedMinute = value.minute.toString().padLeft(2, '0');
        time = "$formattedHour:$formattedMinute $period";
      });
    }, onError: (error) {
      print(error);
    });
  }
}
