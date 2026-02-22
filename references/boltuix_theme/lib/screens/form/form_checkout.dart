import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class FormCheckout extends StatefulWidget {
  FormCheckout();

  @override
  FormCheckoutState createState() => new FormCheckoutState();
}

class FormCheckoutState extends State<FormCheckout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          title: Text("Checkout"),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_vert_rounded),
              onPressed: () {},
            ),
          ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(height: 5),
                Text("Full Name", style: TextStyle(color: MyColors.grey_40)),
                Container(
                  height: 45,
                  child: TextField(
                      maxLines: 1,
                      controller:
                          new TextEditingController(text: "John Smith")),
                ),
                Container(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text("Card number",
                          style: TextStyle(color: MyColors.grey_40)),
                    ),
                    Container(width: 15),
                    Expanded(
                      flex: 2,
                      child: Text("Security code",
                          style: TextStyle(color: MyColors.grey_40)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 45,
                        child: TextField(
                          maxLines: 1,
                          controller: new TextEditingController(
                              text: "4522 **** **** ****"),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 45,
                        child: TextField(
                          maxLines: 1,
                          controller: new TextEditingController(text: "***"),
                        ),
                      ),
                    )
                  ],
                ),
                Container(height: 20),
                Text("Expiration date",
                    style: TextStyle(color: MyColors.grey_40)),
                Container(
                  height: 45,
                  child: TextField(
                      maxLines: 1,
                      controller:
                          new TextEditingController(text: "Aug 15, 2023")),
                ),
                Container(height: 20),
                Text("Address", style: TextStyle(color: MyColors.grey_40)),
                Container(
                  height: 45,
                  child: TextField(
                      maxLines: 1,
                      controller:
                          new TextEditingController(text: "8170 Love Lake Dr")),
                ),
                Container(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text("City",
                          style: TextStyle(color: MyColors.grey_40)),
                    ),
                    Container(width: 15),
                    Expanded(
                      flex: 2,
                      child: Text("State",
                          style: TextStyle(color: MyColors.grey_40)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 45,
                        child: TextField(
                          maxLines: 1,
                          controller:
                              new TextEditingController(text: "Grapeview"),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 45,
                        child: TextField(
                          maxLines: 1,
                          controller: new TextEditingController(text: "CA"),
                        ),
                      ),
                    )
                  ],
                ),
                Container(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text("Postal code",
                          style: TextStyle(color: MyColors.grey_40)),
                    ),
                    Container(width: 15),
                    Expanded(
                      flex: 2,
                      child: Text("Country",
                          style: TextStyle(color: MyColors.grey_40)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 45,
                        child: TextField(
                          maxLines: 1,
                          controller: new TextEditingController(text: "98546"),
                        ),
                      ),
                    ),
                    Container(width: 15),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 45,
                        child: TextField(
                          maxLines: 1,
                          controller: new TextEditingController(text: "USA"),
                        ),
                      ),
                    )
                  ],
                ),
                Container(height: 20),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary, elevation: 0),
                    child: Text("PROCESS",
                        style: MyText.subhead(context)!
                            .copyWith(color: Colors.white)),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
