import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';

class SettingSectionedRoute extends StatefulWidget {
  SettingSectionedRoute();

  @override
  SettingSectionedRouteState createState() => new SettingSectionedRouteState();
}

class SettingSectionedRouteState extends State<SettingSectionedRoute> {
  bool isSwitched1 = true;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: CommonAppBar.getPrimaryAppbar(context, "Device Setting")
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionHeader("GENERAL SETTINGS"),
            _buildSettingCard([
              _buildSettingItem("Account", Icons.person, Colors.green[500],
                  onTap: () {}),
              _buildSettingItem("Gmail", Icons.email, Colors.green[500],
                  onTap: () {}),
              _buildSettingItem("Sync Data", Icons.sync, Colors.green[500],
                  onTap: () {}),
            ]),
            _buildSectionHeader("NETWORK"),
            _buildSettingCard([
              _buildSettingItem(
                  "Simcard & Network", Icons.sim_card, Colors.green[500],
                  onTap: () {}),
              _buildSettingItemWithSwitch(
                  "Wifi", Icons.wifi, Colors.green[500], isSwitched1, (value) {
                setState(() {
                  isSwitched1 = value;
                });
              }),
              _buildSettingItemWithSwitch(
                  "Bluetooth", Icons.bluetooth, Colors.green[500], isSwitched2,
                  (value) {
                setState(() {
                  isSwitched2 = value;
                });
              }),
              _buildSettingItem("More", Icons.more_horiz, Colors.green[500],
                  onTap: () {}),
            ]),
            _buildSectionHeader("SOUND"),
            _buildSettingCard([
              _buildSettingItemWithSwitch(
                  "Silent Mode",
                  Icons.do_not_disturb_off,
                  Colors.green[500],
                  isSwitched3, (value) {
                setState(() {
                  isSwitched3 = value;
                });
              }),
              _buildSettingItemWithSwitch("Vibrate Mode", Icons.vibration,
                  Colors.grey[500], isSwitched4, (value) {
                setState(() {
                  isSwitched4 = value;
                });
              }),
              _buildSettingItem(
                  "Sound Volume", Icons.volume_up, Colors.green[500],
                  onTap: () {}),
              _buildSettingItem(
                  "Ringtone", Icons.notifications, Colors.green[500],
                  onTap: () {}),
            ]),
            Container(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      child: Text(title,
          style: MyText.body1(context)!.copyWith(color: Colors.grey[500])),
      margin: EdgeInsets.fromLTRB(15, 18, 15, 0),
    );
  }

  Widget _buildSettingCard(List<Widget> items) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 2,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.greenAccent.withOpacity(0.1),
              Colors.white.withOpacity(0.3)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 10),
            ...items,
            Container(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, Color? iconColor,
      {required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: <Widget>[
            _buildGradientIcon(icon, iconColor),
            Container(width: 10),
            Text(title,
                style: MyText.subhead(context)!.copyWith(
                    color: Colors.grey[600], fontWeight: FontWeight.w500)),
            Spacer(),
            Icon(Icons.chevron_right, size: 25.0, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItemWithSwitch(String title, IconData icon,
      Color? iconColor, bool switchValue, Function(bool) onChanged) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        child: Row(
          children: <Widget>[
            _buildGradientIcon(icon, iconColor),
            Container(width: 10),
            Text(title,
                style: MyText.subhead(context)!.copyWith(
                    color: Colors.grey[600], fontWeight: FontWeight.w500)),
            Spacer(),
            Switch(
              value: switchValue,
              onChanged: onChanged,
              activeColor: MyColors.primary,
              inactiveThumbColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientIcon(IconData icon, Color? iconColor) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.green, Colors.lightGreen],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Icon(icon, size: 25, color: iconColor),
    );
  }
}
