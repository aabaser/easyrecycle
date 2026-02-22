import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class BottomNavigationArticle extends StatefulWidget {
  BottomNavigationArticle();

  @override
  BottomNavigationArticleState createState() =>
      new BottomNavigationArticleState();
}

class BottomNavigationArticleState extends State<BottomNavigationArticle>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController!.addListener(() {});
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      leading: IconButton(
        icon: Icon(Icons.menu_rounded, color: Colors.green[300]),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.green[300]),
            onPressed: () {}),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildSectionTitle(context,
                      "Discover the Most Adorable Toys for Your Little Ones"),
                  _buildSectionSubtitle(context,
                      "From cuddly stuffed animals to interactive learning toys, find the perfect gift for any occasion."),
                  _buildSectionText(context,
                      "Our selection of toys is carefully curated to ensure quality and safety. Each toy is designed to bring joy and stimulate imagination. Explore our collection and find the perfect toy for your child today."),
                  SizedBox(height: 20),
                  _buildImage('image_002.png'),
                  SizedBox(height: 20),
                  _buildSectionHeader(context, "Why Choose Our Toys?"),
                  _buildSectionText(context,
                      "Our toys are not only adorable but also educational. Each toy is designed to help develop key skills such as fine motor skills, cognitive abilities, and social interaction. Whether it's a plush teddy bear or an interactive robot, our toys will keep your child entertained and engaged."),
                  SizedBox(height: 20),
                  _buildSectionHeader(context, "Customer Reviews"),
                  _buildSectionText(context,
                      "Our customers love our toys! Read what they have to say about their experience with our products. 'The best toys I've ever purchased for my kids!', 'High-quality and super cute!', 'My child loves playing with these toys every day.'"),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
        _buildBottomNavigationBar(),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: MyText.body1(context)!.copyWith(
        color: MyColors.grey_90,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSectionSubtitle(BuildContext context, String subtitle) {
    return Text(
      subtitle,
      style: MyText.body1(context)!.copyWith(
        color: MyColors.grey_90,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSectionText(BuildContext context, String text) {
    return Text(
      text,
      //  textAlign: TextAlign.justify,
      style: MyText.body1(context)!.copyWith(color: MyColors.grey_80),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String header) {
    return Text(
      header,
      textAlign: TextAlign.start,
      style: MyText.medium(context).copyWith(
        color: MyColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    return Container(
      child: Image.asset(Img.get(imagePath), fit: BoxFit.cover),
      width: double.infinity,
      height: 300,
    );
  }

  Widget _buildBottomNavigationBar() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.all(0),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: TabBar(
          indicatorColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 1,
          unselectedLabelColor: MyColors.grey_10,
          labelColor: Colors.green[300],
          tabs: [
            Tab(icon: Icon(Icons.view_module_rounded)),
            Tab(icon: Icon(Icons.data_usage_rounded)),
            Tab(icon: Icon(Icons.account_balance_rounded)),
            Tab(icon: Icon(Icons.folder_rounded)),
            Tab(icon: Icon(Icons.account_circle_rounded)),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
