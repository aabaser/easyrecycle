import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';
import 'package:boltuix/widgets/toolbar.dart';
import 'package:lottie/lottie.dart';

class NoItemInternetIcon extends StatefulWidget {
  NoItemInternetIcon();

  @override
  NoItemInternetIconState createState() => new NoItemInternetIconState();
}

class NoItemInternetIconState extends State<NoItemInternetIcon> {
  bool finishLoading = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar.getPrimarySettingAppbar(context, "My Cart")
          as PreferredSizeWidget?,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: 300,
          child: InkWell(
            onTap: () {
              setState(() {
                finishLoading = false;
              });
              delayShowingContent();
            },
            child: Stack(
              children: <Widget>[
                finishLoading
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Lottie.asset('assets/images/lottie_no_internet.json',
                              width: 130, height: 130),
                          Container(height: 10),
                          Text("No connection",
                              style: MyText.title(context)!.copyWith(
                                  color: MyColors.grey_90,
                                  fontWeight: FontWeight.bold)),
                          Container(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.refresh,
                                  color: MyColors.grey_90, size: 15),
                              Container(width: 5),
                              Text("Tap to retry",
                                  style: MyText.subhead(context)!
                                      .copyWith(color: MyColors.grey_90))
                            ],
                          ),
                        ],
                      )
                    : CircularProgressIndicator(),
              ],
            ),
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
