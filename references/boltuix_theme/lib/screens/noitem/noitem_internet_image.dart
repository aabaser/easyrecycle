import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/widgets/my_text.dart';

class NoItemInternetImage extends StatefulWidget {
  NoItemInternetImage();

  @override
  NoItemInternetImageState createState() => new NoItemInternetImageState();
}

class NoItemInternetImageState extends State<NoItemInternetImage> {
  bool finishLoading = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.white)),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: 280,
          child: Stack(
            children: <Widget>[
              finishLoading
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(Img.get('no_internet.png'),
                            width: 250, height: 250),
                        Text("Whoops!",
                            style: MyText.display1(context)!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Container(height: 10),
                        Text(
                            "No internet connections found. Check your connection or try again",
                            textAlign: TextAlign.center,
                            style: MyText.medium(
                                context) //.copyWith(color: Colors.orange)
                            ),
                        Container(height: 25),
                        Container(
                          width: 180,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text("RETRY",
                                style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              setState(() {
                                finishLoading = false;
                              });
                              delayShowingContent();
                            },
                          ),
                        )
                      ],
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void delayShowingContent() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        finishLoading = true;
      });
    });
  }
}
