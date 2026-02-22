import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen();

  @override
  SettingsScreenState createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool isRealTimeModeEnabled = true, isGameSoundEnabled = true;
  bool isRecommendedTournamentsEnabled = true, isNewDealsEnabled = true;
  bool isPromotionsEnabled = false, isEventNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: Container(),
        preferredSize: Size.fromHeight(0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionTitle("App Settings"),
            _buildSettingOption(
              context,
              "Select Language",
              trailingText: "English, US",
              onTap: () {},
            ),
            _buildDivider(),
            _buildSwitchOption(
              context,
              "Enable Real-Time Mode",
              description:
                  "Stay updated with real-time notifications and alerts.",
              value: isRealTimeModeEnabled,
              onChanged: (value) {
                setState(() {
                  isRealTimeModeEnabled = value;
                });
              },
            ),
            _buildDivider(),
            _buildSwitchOption(
              context,
              "Enable Game Sound",
              description:
                  "Play sounds during gameplay for a more immersive experience.",
              value: isGameSoundEnabled,
              onChanged: (value) {
                setState(() {
                  isGameSoundEnabled = value;
                });
              },
            ),
            SizedBox(height: 25),
            _buildSectionTitle("Notification Settings"),
            _buildSwitchOption(
              context,
              "Recommended Tournaments",
              value: isRecommendedTournamentsEnabled,
              onChanged: (value) {
                setState(() {
                  isRecommendedTournamentsEnabled = value;
                });
              },
            ),
            _buildDivider(),
            _buildSwitchOption(
              context,
              "New Deals & Rewards",
              value: isNewDealsEnabled,
              onChanged: (value) {
                setState(() {
                  isNewDealsEnabled = value;
                });
              },
            ),
            _buildDivider(),
            _buildSwitchOption(
              context,
              "Occasional Promotions",
              value: isPromotionsEnabled,
              onChanged: (value) {
                setState(() {
                  isPromotionsEnabled = value;
                });
              },
            ),
            _buildDivider(),
            _buildSwitchOption(
              context,
              "Event Notifications",
              value: isEventNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  isEventNotificationsEnabled = value;
                });
              },
            ),
            SizedBox(height: 25),
            _buildSectionTitle("More Options"),
            _buildSettingOption(
              context,
              "Ask a Question",
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingOption(
              context,
              "Frequently Asked Questions",
              onTap: () {},
            ),
            _buildDivider(),
            _buildSettingOption(
              context,
              "Privacy Policy",
              onTap: () {},
            ),
            _buildDivider(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Text(
        title,
        style: MyText.medium(context).copyWith(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingOption(
    BuildContext context,
    String title, {
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: MyText.button(context)!.copyWith(
                color: MyColors.grey_90,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            if (trailingText != null)
              Text(
                trailingText,
                style: MyText.medium(context).copyWith(color: MyColors.primary),
              ),
            if (trailingText != null) SizedBox(width: 10),
            Icon(CupertinoIcons.forward, color: MyColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption(
    BuildContext context,
    String title, {
    String? description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  title,
                  style: MyText.body1(context)!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: MyColors.primary,
                  inactiveThumbColor: Colors.grey,
                ),
              ],
            ),
            if (description != null)
              Text(
                description,
                style: MyText.body1(context)!.copyWith(
                  color: Colors.grey[400],
                ),
              ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.green.withOpacity(0.3));
  }
}
