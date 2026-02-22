import 'package:flutter/material.dart';
import 'package:boltuix/widgets/toolbar.dart';
import 'dialog_about_project.dart';
import 'dialog_custom_badge.dart';
import 'dialog_custom_info.dart';
import 'dialog_gdpr_basic.dart';
import 'dialog_multi_choice.dart';
import 'dialog_single_choice.dart';
import 'material_dialogs.dart'; // New common dialogs file

class MaterialDialog extends StatefulWidget {
  MaterialDialog();

  @override
  MaterialDialogState createState() => new MaterialDialogState();
}

class MaterialDialogState extends State<MaterialDialog> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Material Dialog")
          as PreferredSizeWidget?,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            dialogOption(context, "Confirmation Dialog",
                () => CommonDialogs.confirmationDialog(context)),
            dialogOption(context, "Alert Dialog",
                () => CommonDialogs.alertDialog(context)),
            dialogOption(
                context,
                "Single Choice Dialog",
                () => showDialog(
                    context: context, builder: (_) => SingleChoiceDialog())),
            dialogOption(
                context,
                "Multiple Choice Dialog",
                () => showDialog(
                    context: context, builder: (_) => MultiChoiceDialog())),
            dialogOption(
                context,
                "Privacy Policy Dialog",
                () => showDialog(
                    context: context, builder: (_) => GdprBasicDialog())),
            dialogOption(
                context,
                "Badge Dialog",
                () => showDialog(
                    context: context, builder: (_) => CustomLevelDialog())),
            dialogOption(
                context,
                "How to Use Bolt AI?",
                () =>
                    showDialog(context: context, builder: (_) => DialogHelp())),
            dialogOption(
                context,
                "Contact Dialog",
                () => showDialog(
                    context: context, builder: (_) => DialogAboutProject())),
            dialogOption(
                context,
                "About Dialog - License",
                () => showAboutDialog(
                      context: context,
                      applicationIcon: const FlutterLogo(),
                      applicationName: 'Flutter Boltuix - App template',
                      applicationVersion: 'August 2025',
                      applicationLegalese: '\u{a9} 2025 The Boltuix Authors',
                      // children: aboutBoxChildren,
                    )),
          ],
        ),
      ),
    );
  }

  Widget dialogOption(BuildContext context, String title, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50,
          child: InkWell(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(title,
                    style: TextStyle(
                        color: Colors.grey[700], fontWeight: FontWeight.w500)),
              ),
            ),
            onTap: onTap,
          ),
        ),
        Divider(color: Colors.grey[200], height: 0, thickness: 0.5),
      ],
    );
  }
}
