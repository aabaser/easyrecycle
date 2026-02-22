import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_toast.dart';

import '../../widgets/my_text.dart';

class ToastSnackbarBasicRoute extends StatefulWidget {
  ToastSnackbarBasicRoute();

  @override
  ToastSnackbarBasicRouteState createState() =>
      new ToastSnackbarBasicRouteState();
}

class ToastSnackbarBasicRouteState extends State<ToastSnackbarBasicRoute> {
  late BuildContext _scaffoldCtx;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Text("Snackbars & Toasts"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        _scaffoldCtx = context;
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Toast",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_90),
                  ),
                  Container(height: 10, width: 0),
                  Text(
                    "Show a simple toast message",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: MyColors.primary),
                      child:
                          Text("SIMPLE", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        showSimpleToast(context);
                      },
                    ),
                  ),
                  Text(
                    "Show a toast with primary color",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: MyColors.primary),
                      child: Text("COLORED PRIMARY",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        showColoredPrimaryToast(context);
                      },
                    ),
                  ),
                  Container(height: 10, width: 0),
                  Container(width: 300, height: 1, color: Colors.grey[300]),
                  Container(height: 10, width: 0),
                  Text(
                    "Snackbar",
                    style: MyText.subhead(context)!
                        .copyWith(color: MyColors.grey_90),
                  ),
                  Container(height: 10, width: 0),
                  Text(
                    "Show a simple snackbar message",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: MyColors.primary),
                      child:
                          Text("SIMPLE", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        showSimpleSnackbar(context);
                      },
                    ),
                  ),
                  Text(
                    "Show a snackbar with an action button",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: MyColors.primary),
                      child: Text("WITH ACTION",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        snackBarWithAction(context);
                      },
                    ),
                  ),
                  Text(
                    "Show an indefinite snackbar with an action button",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          backgroundColor: MyColors.primary),
                      child: Text("WITH ACTION INDEFINITE",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        snackBarWithActionIndefinite(context);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  void showSimpleToast(BuildContext context) {
    MyToast.show("Simple Toast", context);
  }

  void showColoredPrimaryToast(BuildContext context) {
    MyToast.show("Colored Primary", context, backgroundColor: MyColors.primary);
  }

  void showColoredAccentToast(BuildContext context) {
    MyToast.show("Colored Primary", context, backgroundColor: MyColors.accent);
  }

  void showSimpleSnackbar(BuildContext context) {
    ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(SnackBar(
      content: Text("Simple Snackbar"),
      duration: Duration(seconds: 1),
    ));
  }

  void snackBarWithAction(BuildContext context) {
    ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(SnackBar(
      content: Text("Snackbar With Action"),
      duration: Duration(seconds: 2),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {},
      ),
    ));
  }

  void snackBarWithActionIndefinite(BuildContext context) {
    ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(SnackBar(
      content: Text("Snackbar With Action INDEFINITE"),
      duration: Duration(days: 2),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(SnackBar(
            content: Text("UNDO CLICKED!"),
            duration: Duration(seconds: 1),
          ));
        },
      ),
    ));
  }
}
