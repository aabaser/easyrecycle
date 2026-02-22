import 'package:flutter/material.dart';
import 'package:boltuix/widgets/toolbar.dart';

class SnackbarLiftFabRoute extends StatefulWidget {
  SnackbarLiftFabRoute();

  @override
  SnackbarLiftFabRouteState createState() => SnackbarLiftFabRouteState();
}

class SnackbarLiftFabRouteState extends State<SnackbarLiftFabRoute> {
  late BuildContext _scaffoldCtx;

  void showSnackbar() {
    ScaffoldMessenger.of(_scaffoldCtx).showSnackBar(
      SnackBar(
        content: Text("Floating Action Button clicked!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CommonAppBar.getPrimaryAppbar(context, "Snackbar & FAB")
          as PreferredSizeWidget?,
      body: Builder(builder: (BuildContext context) {
        _scaffoldCtx = context;
        return Center(
          child: Text(
            "Tap the Floating Action Button below to show a Snackbar.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: showSnackbar,
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
