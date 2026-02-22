import 'dart:async';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackdropAppSettings extends StatefulWidget {
  @override
  BackdropAppSettingsState createState() => new BackdropAppSettingsState();
}

class BackdropAppSettingsState extends State<BackdropAppSettings>
    with TickerProviderStateMixin {
  late BuildContext _scaffoldCtx;

  // Observable state variables for switches
  RxBool notificationsEnabled = true.obs;
  RxBool darkModeEnabled = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(milliseconds: 500), () {
        Backdrop.of(_scaffoldCtx).revealBackLayer();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      backgroundColor: Colors.green[700],
      backLayerBackgroundColor: Colors.green[700],
      animationCurve: Curves.easeInOut,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 700), value: 1),
      appBar: BackdropAppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "App Settings",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        actions: <Widget>[
          BackdropToggleButton(
              color: Colors.white, icon: AnimatedIcons.close_menu),
        ],
      ),
      headerHeight: 300,
      frontLayerBorderRadius: BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      backLayer: Builder(
        builder: (BuildContext context) {
          _scaffoldCtx = context;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[700]!, Colors.green[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
                Obx(() => _buildSwitchTile(
                      icon: Icons.notifications_active_rounded,
                      title: "Enable Notifications",
                      value: notificationsEnabled.value,
                      onChanged: (bool value) {
                        notificationsEnabled.value = value;
                      },
                    )),
                SizedBox(height: 15),
                Obx(() => _buildSwitchTile(
                      icon: Icons.dark_mode_rounded,
                      title: "Enable Dark Mode",
                      value: darkModeEnabled.value,
                      onChanged: (bool value) {
                        darkModeEnabled.value = value;
                      },
                    )),
                SizedBox(height: 15),
                _buildSettingsTile(
                    icon: Icons.account_circle_rounded,
                    title: "Manage Account"),
                _buildSettingsTile(
                    icon: Icons.lock_rounded, title: "Privacy & Security"),
                _buildSettingsTile(
                    icon: Icons.language_rounded, title: "Language"),
                _buildSettingsTile(
                    icon: Icons.update_rounded, title: "Update Preferences"),
                _buildSettingsTile(
                    icon: Icons.info_rounded, title: "About App"),
              ],
            ),
          );
        },
      ),
      frontLayerScrim: Colors.transparent,
      frontLayer: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Customize your app settings using the options in the menu.",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Switch(
        value: value,
        activeColor: Colors.white,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$title selected")),
        );
      },
    );
  }
}
