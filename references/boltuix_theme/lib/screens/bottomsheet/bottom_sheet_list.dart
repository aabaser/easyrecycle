import 'package:flutter/material.dart';
import 'package:boltuix/widgets/my_text.dart';

class BottomSheetList extends StatefulWidget {
  BottomSheetList();

  @override
  BottomSheetListState createState() => new BottomSheetListState();
}

class BottomSheetListState extends State<BottomSheetList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Bottom sheet list", style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Text("Press button \nbelow",
            textAlign: TextAlign.center,
            style: MyText.display1(context)!.copyWith(color: Colors.grey[300])),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        backgroundColor: Colors.green[500],
        elevation: 3,
        child: Icon(
          Icons.arrow_upward,
          color: Colors.white,
        ),
        onPressed: () {
          showSheet(context);
        },
      ),
    );
  }
}

void showSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.visibility_rounded),
                title: Text("Preview"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.person_add_rounded),
                title: Text("Share"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.link_rounded),
                title: Text("Get link"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.content_copy_rounded),
                title: Text("Make a copy"),
                onTap: () {},
              ),
            ],
          ),
        );
      });
}
