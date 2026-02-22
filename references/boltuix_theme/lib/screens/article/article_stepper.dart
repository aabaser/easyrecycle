import 'package:flutter/material.dart';
import 'package:boltuix/data/img.dart';
import 'package:boltuix/data/my_colors.dart';
import 'package:boltuix/widgets/my_text.dart';

class ArticleStepper extends StatefulWidget {
  ArticleStepper();

  @override
  ArticleStepperState createState() => new ArticleStepperState();
}

class ArticleStepperState extends State<ArticleStepper> {
  PageController pageController = PageController(
    initialPage: 0,
  );
  int page = 0;
  int max = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: Container(color: MyColors.grey_5),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView(
                onPageChanged: onPageViewChange,
                controller: pageController,
                children: <Widget>[
                  buildPageTitle(),
                  buildPageContent(
                      "3D color technology revolutionizes the way we perceive visuals on screens. By adding depth and dimension to traditional 2D colors, "
                      "3D color enhances the viewing experience, making it more immersive and realistic. This technology is particularly impactful in the fields of virtual reality and augmented reality, "
                      "where the sense of depth can significantly enhance user engagement and interaction. Furthermore, 3D color allows for more accurate representations of textures and materials, "
                      "providing a richer visual experience. As the technology continues to evolve, we can expect even more sophisticated applications that will blur the lines between digital and physical realities. "
                      "The adoption of 3D color in video games and movies has already shown how powerful this technology can be in creating believable worlds and characters. As we look to the future, "
                      "3D color will likely play a pivotal role in the development of new forms of digital art and storytelling, offering artists unprecedented creative opportunities."),
                  buildPageContent(
                      "The science behind 3D color involves the manipulation of light and shadow. By simulating how light interacts with objects in the real world, 3D color creates a sense of volume and space that tricks our eyes into seeing depth where there is none. "
                      "This effect is achieved through the use of advanced algorithms that calculate the way light would behave in a three-dimensional space. These algorithms take into account various factors such as the angle of light, "
                      "the texture of surfaces, and the presence of shadows. The result is a highly realistic depiction of objects that can fool the eye into perceiving depth. "
                      "In addition to enhancing visual realism, 3D color also opens up new possibilities for visual communication. For example, it can be used in medical imaging to provide clearer and more detailed views of complex anatomical structures, "
                      "helping doctors make more accurate diagnoses. In the realm of education, 3D color can bring abstract concepts to life, making them easier to understand and engage with. "
                      "As this technology becomes more accessible, we can expect to see its applications expand into many other areas, transforming the way we interact with digital content."),
                  buildPageContent(
                      "3D color is not only used in entertainment and media but also in practical applications such as medical imaging and design. It helps professionals visualize complex structures and patterns, providing insights that were previously impossible to achieve. "
                      "For instance, in the field of architecture, 3D color can be used to create detailed visualizations of building designs, allowing architects and clients to explore and evaluate different design options before construction begins. "
                      "In the medical field, 3D color imaging is used to produce detailed scans of the human body, aiding in the diagnosis and treatment of various conditions. "
                      "This technology has also found applications in the automotive industry, where it is used to create realistic renderings of car designs, helping manufacturers to refine their products and improve their appeal to consumers. "
                      "Moreover, 3D color is being used in education to create interactive learning experiences that can help students better understand complex subjects. "
                      "As the technology continues to advance, we can expect to see even more innovative uses for 3D color, further expanding its impact across different industries. "
                      "The potential of 3D color technology is vast, and its continued development will undoubtedly lead to many exciting new applications in the future."),
                ],
              ),
            ),
            Container(
              height: 55,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon:
                        Icon(Icons.arrow_back_rounded, color: MyColors.grey_60),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: buildDots(context),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chat_bubble_outline_rounded,
                        color: MyColors.grey_60),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onPageViewChange(int _page) {
    page = _page;
    setState(() {});
  }

  Widget buildPageTitle() {
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset(Img.get('bg_image1.png'),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5)
              ],
            )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("3D Color".toUpperCase(),
                      style: MyText.subhead(context)!
                          .copyWith(color: MyColors.grey_10)),
                  Text("The Future of Visual Experience",
                      style: MyText.display1(context)!
                          .copyWith(color: MyColors.grey_3)),
                  Container(
                      width: 100,
                      height: 2,
                      color: MyColors.grey_10,
                      margin: EdgeInsets.symmetric(vertical: 10)),
                  Text("by BOLT UIX",
                      style: MyText.subhead(context)!.copyWith(
                          color: MyColors.grey_20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPageContent(String text) {
    return Container(
      padding: EdgeInsets.all(15),
      color: MyColors.grey_5,
      child: Stack(
        children: <Widget>[
          Text(text,
              textAlign: TextAlign.justify,
              style: MyText.body1(context)
                  ?.copyWith(color: MyColors.grey_80, height: 1.6))
        ],
      ),
    );
  }

  Widget buildDots(BuildContext context) {
    List<Widget> dots = [];
    for (int i = 0; i < max; i++) {
      dots.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        height: 6,
        width: 6,
        child: CircleAvatar(
          backgroundColor: page == i ? Colors.black : MyColors.grey_20,
        ),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: dots,
    );
  }
}
