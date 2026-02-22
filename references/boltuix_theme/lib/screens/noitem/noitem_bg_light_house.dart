import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class NoItemBgLightHouse extends StatefulWidget {
  NoItemBgLightHouse();

  @override
  NoItemBgLightHouseState createState() => new NoItemBgLightHouseState();
}

class NoItemBgLightHouseState extends State<NoItemBgLightHouse> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        //EbackgroundColor: MyColors.grey_10,
        appBar: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
            backgroundColor: Colors.white,
            title: Text("Account",
                style:
                    MyText.title(context)!.copyWith(color: MyColors.grey_90)),
            leading: IconButton(
              icon: Icon(Icons.menu_rounded, color: MyColors.grey_90),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_vert_rounded, color: MyColors.grey_90),
                onPressed: () {},
              ),
            ]),
        floatingActionButton: FloatingActionButton(
          heroTag: "fab3",
          backgroundColor: Colors.white,
          elevation: 3,
          child: Icon(Icons.person_add, color: Colors.blue),
          onPressed: () {
            print('Clicked');
          },
        ),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                Img.get('empty_state_light_house.png'),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                width: 380,
                child: Text(
                    "There is no account available \nTap button below to add new account",
                    textAlign: TextAlign.center,
                    style: MyText.medium(context)
                        .copyWith(color: MyColors.grey_60)),
              ),
            ),
          ],
        ));
  }
}
