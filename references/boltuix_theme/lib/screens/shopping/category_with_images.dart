import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/adapter/list_category_image_adapter.dart';
import 'package:boltuix/data/dummy.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/model/shop_category.dart';
import 'package:boltuix/widgets/my_toast.dart';

class CategoryWithImages extends StatefulWidget {
  CategoryWithImages();

  @override
  CategoryWithImagesState createState() => new CategoryWithImagesState();
}

class CategoryWithImagesState extends State<CategoryWithImages> {
  late BuildContext context;
  void onItemClick(int index, ShopCategory obj) {
    MyToast.show("News " + index.toString() + "clicked", context,
        duration: MyToast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    List<ShopCategory> items = Dummy.getShoppingCategory();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
          backgroundColor: MyColors.primary,
          title: Text("Categories", style: TextStyle(color: MyColors.grey_10)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: MyColors.grey_10),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart, color: MyColors.grey_10),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.more_vert_rounded, color: MyColors.grey_10),
              onPressed: () {},
            ), // overflow menu
          ]),
      body: ListCategoryImageAdapter(items, onItemClick).getView(),
    );
  }
}
