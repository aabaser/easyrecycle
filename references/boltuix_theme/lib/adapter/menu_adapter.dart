import 'package:flutter/material.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/menu.dart';

class MenuAdapter {
  List items = <Menu>[];
  List itemsTile = <MenuTile>[];

  MenuAdapter(this.items, onItemClick) {
    for (var i = 0; i < items.length; i++) {
      itemsTile.add(MenuTile(index: i, object: items[i], onClick: onItemClick));
    }
  }
}

// ignore: must_be_immutable
class MenuTile extends StatelessWidget {
  final Menu object;
  final int index;
  final Function onClick;

  const MenuTile({
    Key? key,
    required this.index,
    required this.object,
    required this.onClick,
  }) : super(key: key);

  void onItemClick(Menu obj) {
    obj.expand = !obj.expand;
    onClick(index, obj);
  }

  @override
  Widget build(BuildContext ctx) {
    if (object.type == "DIVIDER") {
      return SizedBox(
          height: 20); //Divider(thickness: 0.2, color: Colors.green[500]);
    }
    if (object.type == "SPACER") {
      return Container(height: 50);
    }
    return Material(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          getContainerClickable(getItemView(ctx, object), object, onItemClick),
          object.expand
              ? Column(
                  children: getSubItemViews(ctx, object.subs as List<Menu>),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget getContainerClickable(Widget widget, Menu obj, Function func) {
    return InkWell(
      highlightColor: Colors.greenAccent[300],
      splashColor: Colors.greenAccent[100],
      onTap: () => func(obj),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: widget,
      ),
    );
  }

  Widget gradientIcon(
      IconData icon, double size, Color gradient1, Color gradient2) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: <Color>[gradient1, gradient2],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Icon(icon, size: size, color: Colors.white),
    );
  }

  Widget gradientBullet(double size, Color gradient1, Color gradient2) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: <Color>[gradient1, gradient2],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: Icon(Icons.brightness_1, size: size, color: Colors.white),
    );
  }

  Widget getItemView(BuildContext ctx, Menu obj) {
    bool sub = obj.subs.isEmpty;
    bool isChild = obj.type == "CHILD";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Card(
        elevation: 5, // Adjust elevation as needed
        color: Colors.white, // Card background color
        shadowColor: MyColors.gradient1.withOpacity(0.5), // Shadow color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(45),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isChild ? 15.0 : 5.0,
            horizontal: isChild ? 20.0 : 0.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sub
                  ? Container(width: 40)
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: gradientIcon(
                        obj.icon!,
                        70.0,
                        MyColors.gradient1,
                        MyColors.gradient2,
                      ),
                    ),
              if (isChild)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child:
                      gradientBullet(8, MyColors.gradient1, MyColors.gradient2),
                ),
              Expanded(
                child: Text(
                  obj.title,
                  style: TextStyle(
                    fontWeight: obj.expand && !isChild
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: isChild ? 15 : 20,
                    letterSpacing: isChild ? 1.0 : 1.5,
                    color: obj.expand && !isChild
                        ? Colors.green
                        : Colors.black, // Conditional color
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 4, 10, 0),
                height: 6,
                width: 6,
                child: CircleAvatar(
                  backgroundColor: obj.newPage
                      ? MyColors.accentDark.withOpacity(0.6)
                      : Colors.transparent,
                ),
              ),
              if (!sub)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: gradientIcon(
                    obj.expand
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    35.0,
                    MyColors.gradient1,
                    MyColors.gradient2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getSubItemViews(BuildContext ctx, List<Menu> subs) {
    List widgets = <Widget>[];
    for (Menu m in subs) {
      widgets.add(getContainerClickable(getItemView(ctx, m), m, onItemClick));
    }
    return widgets as List<Widget>;
  }
}
