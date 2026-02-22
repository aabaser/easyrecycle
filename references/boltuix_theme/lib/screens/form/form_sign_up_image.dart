import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/widgets/my_text.dart';

class FormSignUpImage extends StatefulWidget {
  FormSignUpImage();

  @override
  FormSignUpImageState createState() => new FormSignUpImageState();
}

class FormSignUpImageState extends State<FormSignUpImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(Img.get('bg_green.webp'),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover),
          Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.green[800]!.withOpacity(0.9)),
          SingleChildScrollView(
            padding: EdgeInsets.all(25),
            scrollDirection: Axis.vertical,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 70),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        maxLines: 1,
                        style: MyText.subhead(context)!
                            .copyWith(color: Colors.white),
                        controller: new TextEditingController(
                            text: "John Smith Turner"),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(-12),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(height: 20),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        maxLines: 1,
                        style: MyText.subhead(context)!
                            .copyWith(color: Colors.white),
                        controller: new TextEditingController(
                            text: "John Smith.turner"),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(-12),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(height: 20),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        maxLines: 1,
                        style: MyText.subhead(context)!
                            .copyWith(color: Colors.white),
                        controller: new TextEditingController(text: "password"),
                        obscureText: true,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(-12),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(height: 20),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        maxLines: 1,
                        style: MyText.subhead(context)!
                            .copyWith(color: Colors.white),
                        controller: new TextEditingController(
                            text: "John Smith.turner@mail.com"),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(-12),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Container(width: 15),
                                Expanded(
                                  child: TextField(
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    style: MyText.subhead(context)!
                                        .copyWith(color: Colors.white),
                                    controller: new TextEditingController(
                                        text: "29 y.o"),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(-12),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                        Container(width: 20),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Container(width: 15),
                                Expanded(
                                  child: TextField(
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    style: MyText.subhead(context)!
                                        .copyWith(color: Colors.white),
                                    controller:
                                        new TextEditingController(text: "Male"),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(-12),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down, color: Colors.white)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(height: 20),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: <Widget>[
                          Container(width: 15),
                          Expanded(
                            child: TextField(
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              style: MyText.subhead(context)!
                                  .copyWith(color: Colors.white),
                              controller: new TextEditingController(
                                  text: "United State"),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(-12),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.white)
                        ],
                      ),
                    ),
                    Container(height: 20),
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white.withOpacity(0.6),
                            elevation: 0),
                        child: Text("SUBMIT",
                            style: MyText.body2(context)!
                                .copyWith(color: Colors.green)),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
              height: kToolbarHeight,
              child: AppBar(
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarBrightness: Brightness.dark),
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.more_vert_rounded),
                      onPressed: () {},
                    ),
                  ]))
        ],
      ),
    );
  }
}
