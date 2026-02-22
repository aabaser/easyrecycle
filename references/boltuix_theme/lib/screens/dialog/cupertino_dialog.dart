import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/toolbar.dart';
import '../../widgets/m_typography.dart';

class CupertinoDialog extends StatefulWidget {
  const CupertinoDialog({super.key});

  @override
  CupertinoDialogState createState() => CupertinoDialogState();
}

class CupertinoDialogState extends State<CupertinoDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "Cupertino Dialog")
          as PreferredSizeWidget?,
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(height: 45),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Alert Dialog Simple",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    showDialogInfo();
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Alert Dialog "
                        "",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Alert Dialog Logout");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Alert Dialog Info",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Alert Dialog Info");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Alert Dialog Selection",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Alert Dialog Selection");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: InkWell(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Action Sheet",
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    onMenuClicked("Action Sheet");
                  },
                ),
              ),
              Divider(color: Colors.grey[400], height: 0, thickness: 0.5),
            ],
          ),
        );
      }),
    );
  }

  void onMenuClicked(String menu) {
    if (menu == "Alert Dialog Logout") {
      // Create a new text theme that applies the display color to the text
      final textTheme = Theme.of(context)
          .textTheme
          .apply(displayColor: Theme.of(context).colorScheme.onSurface);

// Show a Cupertino-style dialog box
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          // Add a title to the dialog with the 'Logout?' text, using the textTheme to apply styles
          title: TextStyleExample(
            name: 'Logout?',
            style: textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add content to the dialog with the 'Are you sure want to logout?' text, using the textTheme to apply styles
          content: TextStyleExample(
            name: 'Are you sure want to logout?',
            style: textTheme.titleSmall!,
          ),
          // Add two actions to the dialog: Cancel and Logout
          actions: [
            CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Cancel',
                style: textTheme.labelLarge!,
              ),
              onPressed: () {
                // Handle the 'Cancel' action by dismissing the dialog
                finish(context);
              },
            ),
            CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Logout',
                style: textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                // Handle the 'Logout' action by dismissing the dialog
                finish(context);
              },
            ),
          ],
        ),
      );
    } else if (menu == "Alert Dialog Info") {
      // Create a new text theme that applies the display color to the text
      final textTheme = Theme.of(context)
          .textTheme
          .apply(displayColor: Theme.of(context).colorScheme.onSurface);

      // Show a Cupertino-style dialog box
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          // Add a title to the dialog with the 'Allow Maps to access your location while you use the app?' text, using the textTheme to apply styles
          title: TextStyleExample(
            name: 'Allow Maps to access your location while you use the app?',
            style: textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add content to the dialog with the 'Your current location will be displayed on the map and used for directions,nearby search results, and estimated travel times' text, using the textTheme to apply styles
          content: TextStyleExample(
            name:
                'Your current location will be displayed on the map and used for directions,nearby search results, and estimated travel times',
            style: textTheme.titleSmall!,
          ),
          // Add two actions to the dialog: 'Don't Allow' and 'Allow'
          actions: [
            CupertinoDialogAction(
              child: TextStyleExample(
                name: "Don't Allow",
                style: textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                // Handle the 'Don't Allow' action by dismissing the dialog
                finish(context);
              },
            ),
            CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Allow',
                style: textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // Handle the 'Allow' action by dismissing the dialog
                finish(context);
              },
            ),
          ],
        ),
      );
    } else if (menu == "Alert Dialog Selection") {
      final textTheme = Theme.of(context).textTheme.apply(
          displayColor: Theme.of(context)
              .colorScheme
              .onSurface); // Define the text theme for the dialog

      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: TextStyleExample(
            name: 'Title',
            style: textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.1,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Item 1',
                style: textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                finish(
                    context); // Close the dialog when the "Item 1" button is pressed
              },
            ),
            CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Item 2',
                style: textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                finish(
                    context); // Close the dialog when the "Item 2" button is pressed
              },
            ),
            CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Item 3',
                style: textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                finish(
                    context); // Close the dialog when the "Item 3" button is pressed
              },
            ),
            CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Item 4',
                style: textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () {
                finish(
                    context); // Close the dialog when the "Item 4" button is pressed
              },
            ),
            CupertinoDialogAction(
              child: TextStyleExample(
                name: 'Close',
                style: textTheme.titleLarge!.copyWith(
                  color: Colors.grey,
                  letterSpacing: 0.1,
                ),
              ),
              onPressed: () {
                finish(
                    context); // Close the dialog when the "Close" button is pressed
              },
            ),
          ],
        ),
      );
    } else if (menu == "Action Sheet") {
      final textTheme = Theme.of(context)
          .textTheme
          .apply(displayColor: Theme.of(context).colorScheme.onSurface);

// Show a modal popup that contains a CupertinoActionSheet widget
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
                title: TextStyleExample(
                    name: 'Title',
                    style: textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.1)),
                message: TextStyleExample(
                    name: 'Your description is here',
                    style: textTheme.bodyMedium!.copyWith(letterSpacing: 0.1)),
                actions: <Widget>[
                  // List of actions
                  CupertinoActionSheetAction(
                    child: TextStyleExample(
                        name: 'Action 1',
                        style: textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal popup
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: TextStyleExample(
                        name: 'Action 2',
                        style: textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal popup
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: TextStyleExample(
                        name: 'Action 3',
                        style: textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal popup
                    },
                  )
                ],
                // A cancel button at the bottom of the modal popup
                cancelButton: CupertinoActionSheetAction(
                  child: TextStyleExample(
                      name: 'Close',
                      style: textTheme.titleLarge!
                          .copyWith(color: Colors.grey, letterSpacing: 0.1)),
                  onPressed: () {
                    Navigator.pop(context); // Close the modal popup
                  },
                ),
              ));
    }
  }

// Function to show an information dialog or alert dialog
  showDialogInfo() {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Disallows dismissing the dialog by tapping outside it
      builder: (BuildContext context) {
        final textTheme = Theme.of(context)
            .textTheme
            .apply(displayColor: Theme.of(context).colorScheme.onSurface);

        return CupertinoAlertDialog(
          // Dialog title with formatted text
          title: TextStyleExample(
              name: 'Payment Success!',
              style: textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 0.1,
                  fontWeight: FontWeight.bold)),
          // Dialog content with formatted text
          content: TextStyleExample(
              name: 'It is our pleasure to offer you our products',
              style: textTheme.bodyMedium!),
          actions: <Widget>[
            // Button to continue with formatted text
            CupertinoDialogAction(
              child: TextStyleExample(
                  name: 'Continue',
                  style: textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 0.3)),
              onPressed: () {
                Navigator.of(context).pop(); // Dismisses the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

/// Navigate back to the previous screen.
///
/// If there is a previous screen on the navigation stack, this function pops
/// the current screen off the stack and returns to the previous screen. If a
/// [result] is provided, it will be passed back to the previous screen.
void finish(BuildContext context, [Object? result]) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context, result);
  }
}
