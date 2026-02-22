import 'package:flutter/material.dart';
import 'package:boltuix/data/my_strings.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/widgets/my_text.dart';

import '../data/my_colors.dart';

class ListBasicAdapter {
  List? items = <People>[];
  List itemsTile = <ItemTile>[];

  ListBasicAdapter(this.items, onItemClick) {
    for (var i = 0; i < items!.length; i++) {
      itemsTile
          .add(ItemTile(index: i, object: items![i], onClick: onItemClick));
    }
  }

  Widget getView() {
    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => itemsTile[index],
        itemCount: itemsTile.length,
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

// ignore: must_be_immutable
class ItemTile extends StatelessWidget {
  final People object;
  final int index;
  final Function onClick;

  const ItemTile({
    Key? key,
    required this.index,
    required this.object,
    required this.onClick,
  }) : super(key: key);

  void onItemClick(People obj) {
    onClick(index, obj);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemClick(object);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(width: 20),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [MyColors.gradient1, MyColors.gradient2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Text(
                  object.name!
                      .substring(0, 1), // Display first character of the name
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    object.name!,
                    style: MyText.medium(context).copyWith(
                        color: Colors.grey[800], fontWeight: FontWeight.normal),
                  ),
                  Container(height: 5),
                  Text(
                    MyStrings.middle_lorem_ipsum,
                    maxLines: 2,
                    style: MyText.body1(context)!.copyWith(color: Colors.grey),
                  ),
                  Container(height: 15),
                  Divider(color: Colors.lightGreen[100], height: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
