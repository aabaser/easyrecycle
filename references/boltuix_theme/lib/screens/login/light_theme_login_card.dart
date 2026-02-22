import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class LightThemeLoginCard extends StatefulWidget {
  LightThemeLoginCard();

  @override
  LightThemeLoginCardState createState() => new LightThemeLoginCardState();
}

class LightThemeLoginCardState extends State<LightThemeLoginCard> {
  bool _isChecked = false; // State variable for the checkbox

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green.shade50,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.white)),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/logo_f.png',
              width: 200,
              height: 250,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Text("Sign in",
                          style: MyText.title(context)!.copyWith(
                              color: Colors.green[600],
                              fontWeight: FontWeight.bold)),
                      Container(height: 10),
                      Container(height: 4, width: 40, color: Colors.green[700]),
                      Container(height: 25),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                Container(height: 25),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "User name",
                                      labelStyle: MyText.caption(context)),
                                ),
                                Container(height: 25),
                                TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      labelStyle: MyText.caption(context)),
                                ),
                                Container(height: 5),
                                InkWell(
                                  child: Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value:
                                            _isChecked, // Connect checkbox value to the state variable
                                        activeColor: Colors.green[
                                            700], // Set the check color to green
                                        onChanged: (value) {
                                          setState(() {
                                            _isChecked =
                                                value!; // Update the state when checkbox is tapped
                                          });
                                        },
                                      ),
                                      Text("Keep me Signed in",
                                          style: MyText.body2(context)!
                                              .copyWith(
                                                  color: Colors.green[700])),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _isChecked =
                                          !_isChecked; // Toggle the checkbox state on tap
                                    });
                                  },
                                ),
                                Container(height: 5),
                                Row(
                                  children: <Widget>[
                                    Spacer(),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.transparent),
                                      child: Text("Forgot Password?",
                                          style: TextStyle(
                                              color: MyColors.grey_40)),
                                      onPressed: () {},
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green[700], elevation: 0),
                  child: Text("SIGN IN",
                      style: MyText.subhead(context)!
                          .copyWith(color: Colors.black)),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
