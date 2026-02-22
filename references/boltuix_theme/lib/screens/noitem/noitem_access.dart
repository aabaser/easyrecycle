import 'package:flutter/material.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:lottie/lottie.dart';

class NoItemAccess extends StatefulWidget {
  NoItemAccess();

  @override
  NoItemAccessState createState() => new NoItemAccessState();
}

class NoItemAccessState extends State<NoItemAccess> {
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
                        //Image.asset(Img.get('no_internet.png'), width: 250, height: 250),
                        //lottie_no_access.json
                        Lottie.asset('assets/images/lottie_no_access.json',
                            height: 230),

                        Text("Whoops!",
                            style: MyText.display1(context)!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        Container(height: 10),
                        Text(
                            "You do not have access to this page. Please contact the admin.",
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
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            child: Text("Close",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              setState(() {
                                finishLoading = false;
                                // close
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
