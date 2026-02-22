/*generate dummy data*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:boltuix/model/image_obj.dart';
import 'package:boltuix/model/inbox.dart';
import 'package:boltuix/model/model_image.dart';
import 'package:boltuix/model/music_album.dart';
import 'package:boltuix/model/music_song.dart';
import 'package:boltuix/model/news.dart';
import 'package:boltuix/model/people.dart';
import 'package:boltuix/model/photo_info.dart';
import 'package:boltuix/model/review.dart';
import 'package:boltuix/model/shop_category.dart';
import 'package:boltuix/model/shop_product.dart';
import 'package:boltuix/model/wizard.dart';

import 'img.dart';
import 'my_strings.dart';

class Dummy {
  static Random random = new Random();

  static const List<String> images = [
    "image_001.png",
    "image_002.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png"
  ];

  static const List<String> images_name = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
    "Item 6",
  ];

  static const List<String> general_date = [
    "05 Dec 2015",
    "22 Apr 2013",
    "14 Sep 2015",
    "11 Feb 2015",
    "29 Aug 2014",
    "10 Nov 2015",
    "23 Jun 2015",
    "20 Jul 2015",
    "09 Mar 2015",
    "01 Jan 2016",
  ];

  static const List<String> peopleNames = [
    "Alice",
    "Bob",
    "Charlie",
    "Diana",
    "Eve",
    "Frank",
    "Grace",
    "Hank",
    "Ivy",
    "Jack",
    "Karen",
    "Liam",
    "Mia",
    "Nate",
    "Olivia"
  ];

  static const List<String> peopleImages = [
    "image_001.png",
    "image_002.png",
    "image_003.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png",
    "image_008.png",
    "image_001.png",
    "image_002.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png",
    "image_008.png",
  ];

  static const List<String> month = [
    "Sectioned 1",
    "Sectioned 2",
    "Sectioned 3",
    "Sectioned 4",
    "Sectioned 5",
    "Sectioned 6",
    "Sectioned 7",
    "Sectioned 8",
    "Sectioned 9",
    "Sectioned 10",
    "Sectioned 11",
    "Sectioned 12"
  ];

  //  app_shop category data ----------------------------------------------------------------
  static const List<String> shop_category_title = [
    "Category 1",
    "Category 2",
    "Category 3",
    "Category 4",
    "Category 5",
    "Category 6",
    "Category 7",
    "Category 8"
  ];

  static const List<String> shop_category_brief = [
    "100k+ Items", // Category 1
    "650k+ Items", // Category 2
    "220k+ Items", // Category 3
    "85k+ Items", // Category 4
    "720k+ Items", // Category 5
    "1M+ Items", // Category 6
    "500k+ Items", // Category 7
    "360k+ Items", // Category 8
  ];

  static const List<String> shop_category_img = [
    "image_001.png",
    "image_002.png",
    "image_003.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png",
    "image_008.png",
  ];

  static const List<IconData> shop_category_icon = [
    Icons.devices_rounded,
    Icons.accessibility_rounded,
    Icons.face_rounded,
    Icons.child_friendly_rounded,
    Icons.weekend_rounded,
    Icons.pool_rounded,
    Icons.confirmation_number_rounded,
    Icons.restaurant_rounded
  ];

  static const List<Color> md_color_random = [
    Color(0xFFe91e63),
    Color(0xFF9c27b0),
    Color(0xFF673ab7),
    Color(0xFFE53935),
    Color(0xFF5677fc),
    Color(0xFF689F38),
    Color(0xFF03a9f4),
    Color(0xFF00bcd4),
    Color(0xFF009688),
    Color(0xFF259b24),
    Color(0xFFff5722),
    Color(0xFF795548),
    Color(0xFF607d8b),
    Color(0xFFff9800)
  ];

  //  header auto data ---------------------------------------------------------

  static const List<String> images_header_auto = [
    "image_001.png",
    "image_002.png",
    "image_004.png",
    "image_005.png",
    "image_006.png"
  ];

  static const List<String> title_header_auto = [
    "Adorable 3D Teddy Bear",
    "Cute 3D Cupcake with Sprinkles",
    "Charming 3D Worm",
    "Lovely 3D Apple",
    "Sweet 3D Ice Coast",
  ];

  static const List<String> subtitle_header_auto = [
    "Foggy Hill",
    "The Backpacker",
    "River Forest",
    "Mist Mountain",
    "Side Park",
  ];

  //  wizard data --------------------------------------------------------------

  static const List<String> wizard_title = [
    "Feature One",
    "Feature Two",
    "Feature Three",
    "Feature Four"
  ];
  static const List<String> wizard_brief = [
    "Here is your feature one Short notes",
    "Here is your feature two Short notes",
    "Here is your feature three Short notes",
    "Here is your feature four Short notes",
  ];
  static const List<String> wizard_image = [
    "intro1.png",
    "intro2.png",
    "intro3.png",
    "intro4.png",
  ];
  static const List<String> wizard_background = [
    "music_bg.jpg",
    "music_bg.jpg",
    "music_bg.jpg",
    "music_bg.jpg",
  ];

  static const List<Color> wizard_color = [
    Colors.orange,
    Colors.blueGrey,
    Colors.red,
    Colors.pinkAccent,
  ];

  // News Data -----------------------------------------------------------------

  static const List<String> all_images = [
    "image_001.png",
    "image_002.png",
    "image_003.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png",
    "image_008.png",
    "image_001.png",
    "image_002.png",
    "image_003.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png",
    "image_008.png",
    "image_001.png",
    "image_002.png",
    "image_003.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png",
    "image_008.png",
    "image_001.png",
    "image_002.png",
    "image_003.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
  ];

  static const List<String> strings_medium = [
    "Here is the new heading 1 for something interesting.",
    "Here is the new heading 2 for something innovation like that.",
    "Here is the new heading 3 for exploring deeper insights.",
    "Here is the new heading 4 for major sports updates.",
    "Here is the new heading 5 for global business trends.",
    "Here is the new heading 6 for groundbreaking technology.",
    "Here is the new heading 7 for cultural highlights of the year.",
    "Here is the new heading 8 for expert opinions on critical issues.",
    "Here is the new heading 9 for revolutionary science breakthroughs.",
    "Here is the new heading 10 for connecting with the world’s stories."
  ];

  static const List<String> news_category = [
    "Category 1",
    "Category 2",
    "Category 3",
    "Category 4",
    "Category 5",
    "Category 6"
  ];

  static const List<String> full_date = [
    "Sun, 05 Jan 2024",
    "Mon, 22 Feb 2024",
    "Wed, 14 Mar 2024",
    "Fri, 11 Apr 2024",
    "Thu, 29 May 2024",
    "Sat, 10 Jun 2024",
    "Tue, 23 Jul 2024",
    "Wed, 20 Aug 2024",
    "Sun, 09 Sep 2024",
    "Mon, 01 Oct 2024"
  ];

  // app_shop product data ---------------------------------------------------------

  static const List<String> shop_product_image = [
    "image_001.png",
    "image_002.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_007.png"
  ];
  static const List<String> shop_product_title = [
    "Product 1",
    "Product 2",
    "Product 3",
    "Product 4",
    "Product 5",
    "Product 6",
  ];

  static const List<String> shop_product_price = [
    "\$10.90",
    "\$10.00",
    "\$16.80",
    "\$134.50",
    "\$50.00",
    "\$70.00",
  ];

  // music data ----------------------------------------------------------------

  static const List<String> album_cover = [
    "image_001.png",
    "image_002.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_001.png",
    "image_002.png",
    "image_004.png",
    "image_005.png",
    "image_006.png",
    "image_001.png",
    "image_002.png",
    "image_004.png",
    "image_005.png",
    "image_006.png"
  ];

  static const List<String> song_name = [
    "All The Arguments",
    "Proud of You",
    "Morning Reasons",
    "Drowsy Smart Mouth",
    "Being Anything Else",
    "Fist Full Of Mysteries",
    "5 Dollar Town",
    "Eternal Soul",
    "Living is Going Down",
    "Deadly Joy",
    "Screaming Skill",
    "Escape Of The Justice",
    "Silent Fight",
    "Distractions Have No Answers",
    "Lead Sm",
  ];

  static const List<String> album_name = [
    "Album name 1",
    "Album name 2",
    "Album name 3",
    "Album name 4",
    "Album name 5",
    "Album name 6",
    "Album name 7",
    "Album name 8",
    "Album name 9",
    "Album name 10",
    "Album name 11",
    "Album name 12",
    "Album name 13",
    "Album name 14",
    "Album name 15",
  ];

  static const List<String> music_genre = [
    "Soul",
    "Gospel",
    "Punk rock",
    "Electronic",
    "Hip-hop",
    "Alternative",
    "Reggae",
    "Jazz",
    "Instrument",
    "Country",
    "Hard rock",
    "Folk",
    "Acoustic",
    "EDM"
  ];

  static const List<String> music_category = [
    "Retro",
    "New Release",
    "Top Hits",
    "Featured",
    "Indie",
    "Memories"
  ];

  static const List<String> travel_categories = [
    "Beaches",
    "Mountains",
    "Cities",
    "Adventure",
    "Historical",
    "Cultural",
    "Nature",
    "Luxury",
    "Romantic",
    "Family",
    "Wildlife",
    "Road Trips",
    "Winter Sports",
    "Wellness"
  ];

  static const List<String> travel_themes = [
    "Weekend Getaways",
    "Eco-friendly",
    "Budget Travel",
    "Luxury Escapes",
    "Backpacking",
    "Solo Trips",
    "Group Tours",
    "Honeymoon",
    "Last-minute Deals",
    "Seasonal Specials"
  ];

  // Optional: Example to represent categories with icons
  static const List<Map<String, dynamic>> travel_categories_with_icons = [
    {"name": "Beaches", "icon": Icons.beach_access},
    {"name": "Mountains", "icon": Icons.terrain},
    {"name": "Cities", "icon": Icons.location_city},
    {"name": "Adventure", "icon": Icons.hiking},
    {"name": "Historical", "icon": Icons.history_edu},
    {"name": "Cultural", "icon": Icons.museum},
    {"name": "Nature", "icon": Icons.nature},
    {"name": "Luxury", "icon": Icons.spa},
    {"name": "Romantic", "icon": Icons.favorite},
    {"name": "Family", "icon": Icons.family_restroom},
    {"name": "Wildlife", "icon": Icons.pets},
    {"name": "Road Trips", "icon": Icons.directions_car},
    {"name": "Winter Sports", "icon": Icons.ac_unit},
    {"name": "Wellness", "icon": Icons.self_improvement},
  ];

  // review data ----------------------------------------------------------------

  static const List<String> review_image = [
    "photo_male_2.jpg",
    "photo_female_7.jpg",
    "photo_male_7.jpg",
    "photo_female_2.jpg"
  ];
  static const List<String> review_name = [
    "John Smith Turner",
    "Garcia Lewis",
    "Adams Green",
    "Jessica M"
  ];
  static const List<String> review_brief = [
    "20 reviews",
    "152 reviews",
    "86 reviews",
    "55 reviews"
  ];
  static const List<double> review_rating = [4.7, 5, 4, 5];
  static const List<String> review_time = [
    "3 days ago",
    "a week ago",
    "2 week ago",
    "2 week ago"
  ];

  // photo info data
  static const List<String> photo_info_name = [
    "Building",
    "Nature",
    "Nightlife",
    "Person",
    "Moment",
    "Forest",
    "Face",
    "Workout",
    "Landmark",
    "Food",
    "Holiday",
    "Travel",
    "Bike",
    "Shopping",
    "Fashion",
    "Beach"
  ];

  // date data
  static const List<String> generalDate = [
    "05 Dec 2015",
    "22 Apr 2013",
    "14 Sep 2015",
    "11 Feb 2015",
    "29 Aug 2014",
    "10 Nov 2015",
    "23 Jun 2015",
    "20 Jul 2015",
    "09 Mar 2015",
    "01 Jan 2016"
  ];

  static const List<IconData> photo_info_icon = [
    Icons.business,
    Icons.local_florist,
    Icons.local_cafe,
    Icons.person,
    Icons.event_seat,
    Icons.grass,
    Icons.face,
    Icons.fitness_center,
    Icons.pin_drop,
    Icons.restaurant,
    Icons.pool,
    Icons.airport_shuttle,
    Icons.directions_bike,
    Icons.shopping_basket,
    Icons.photo_camera,
    Icons.beach_access
  ];

  static const List<String> review_comment = [
    MyStrings.lorem_ipsum,
    MyStrings.middle_lorem_ipsum,
    MyStrings.long_lorem_ipsum,
    MyStrings.middle_lorem_ipsum
  ];

  static int getRandomIndex(int max) {
    return random.nextInt(max - 1);
  }

  static Color getRandomColor(int index) {
    Color returnColor = Colors.white;
    int idx = index;
    while (idx >= md_color_random.length) {
      idx = idx - 5;
    }
    while (idx < 0) {
      idx = idx + 2;
    }
    returnColor = md_color_random[idx];
    return returnColor;
  }

  static List<String> getNatureImages([int count = 14]) {
    List<String> natureImages = [];
    for (String s in images) {
      natureImages.add(Img.get(s));
    }
    natureImages.shuffle();
    return natureImages.sublist(0, count);
  }

  static List<People> getPeopleData() {
    List<People> items = [];

    for (int i = 0; i < peopleNames.length; i++) {
      People obj = new People();
      obj.image = Img.get(peopleImages[i]);
      obj.name = peopleNames[i];
      obj.email = getEmailFromName(obj.name!);
      items.add(obj);
    }
    items.shuffle();
    return items;
  }

  static List<Inbox> getInboxData() {
    List<Inbox> items = [];

    for (int i = 0; i < peopleNames.length; i++) {
      Inbox obj = new Inbox();
      obj.image = Img.get(peopleImages[i]);
      obj.name = peopleNames[i];
      obj.email = getEmailFromName(obj.name!);
      obj.date = generalDate[random.nextInt(generalDate.length - 1)];
      items.add(obj);
    }
    items.shuffle();
    return items;
  }

  static List<String> getStringsMonth() {
    List<String> items = [];
    for (String s in month) items.add(s);
    return items;
  }

  static String getEmailFromName(String name) {
    if (name.isNotEmpty) {
      String email = name.replaceAll(" ", ".").toLowerCase() + "@mail.com";
      return email;
    }
    return name;
  }

  static List<ShopCategory> getShoppingCategory() {
    List<ShopCategory> items = [];
    for (int i = 0; i < shop_category_title.length; i++) {
      ShopCategory obj = new ShopCategory();
      obj.icon = shop_category_icon[i];
      obj.image = shop_category_img[i];
      obj.title = shop_category_title[i];
      obj.brief = shop_category_brief[i];
      items.add(obj);
    }
    return items;
  }

  static List<ModelImage> getModelImage() {
    final List<ModelImage> items = [];
    for (int i = 0; i < images_header_auto.length; i++) {
      ModelImage obj = new ModelImage();
      obj.image = images_header_auto[i];
      obj.name = title_header_auto[i];
      obj.brief = subtitle_header_auto[i];
      items.add(obj);
    }
    return items;
  }

  static List<ImageObj> getImageDate() {
    List<ImageObj> items = [];
    for (int i = 0; i < images.length; i++) {
      ImageObj obj = new ImageObj();
      obj.image = images[i];
      obj.name = images_name[i];
      obj.brief = general_date[random.nextInt(general_date.length)];
      obj.counter = random.nextInt(100);
      items.add(obj);
    }
    items.shuffle();
    return items;
  }

  static List<Wizard> getWizard() {
    List<Wizard> items = [];
    for (int i = 0; i < wizard_title.length; i++) {
      Wizard obj = new Wizard();
      obj.image = wizard_image[i];
      obj.background = wizard_background[i];
      obj.title = wizard_title[i];
      obj.brief = wizard_brief[i];
      obj.color = wizard_color[i];
      items.add(obj);
    }
    return items;
  }

  static List<News> getNewsData(int count) {
    List<News> items = [];
    for (int i = 0; i < count; i++) {
      News obj = new News();
      obj.image = all_images[random.nextInt(all_images.length)];
      obj.title = strings_medium[random.nextInt(strings_medium.length)];
      obj.subtitle = news_category[random.nextInt(news_category.length)];
      obj.date = full_date[random.nextInt(full_date.length)];
      items.add(obj);
    }
    return items;
  }

  static List<ShopProduct> getShoppingProduct() {
    List<ShopProduct> items = [];
    for (int i = 0; i < shop_product_image.length; i++) {
      ShopProduct obj = new ShopProduct();
      obj.image = shop_product_image[i];
      obj.title = shop_product_title[i];
      obj.price = shop_product_price[i];
      items.add(obj);
    }
    items.shuffle();
    return items;
  }

  static List<MusicSong> getMusicSong() {
    List<MusicSong> items = [];
    for (int i = 0; i < album_cover.length; i++) {
      MusicSong obj = new MusicSong();
      obj.image = album_cover[i];
      obj.title = song_name[i];
      obj.brief = album_name[i];
      items.add(obj);
    }
    items.shuffle();
    return items;
  }

  static List<MusicAlbum> getMusicAlbum() {
    List<MusicAlbum> items = [];
    for (int i = 0; i < album_cover.length; i++) {
      MusicAlbum obj = new MusicAlbum();
      obj.image = album_cover[i];
      obj.name = album_name[i];
      obj.brief = getRandomIndex(15).toString() + " MusicSong (s)";
      obj.color = getRandomColor(i);
      items.add(obj);
    }
    items.shuffle();
    return items;
  }

  static List<Review> getReviews() {
    List<Review> items = [];
    for (int i = 0; i < review_name.length; i++) {
      Review obj = new Review();
      obj.image = review_image[i];
      obj.name = review_name[i];
      obj.brief = review_brief[i];
      obj.rating = review_rating[i];
      obj.timeRating = review_time[i];
      obj.comment = review_comment[i];
      items.add(obj);
    }
    return items;
  }

  static List<PhotoInfo> getPhotoInfo() {
    List<PhotoInfo> items = [];
    for (int i = 0; i < photo_info_name.length; i++) {
      PhotoInfo obj = new PhotoInfo();
      obj.title = photo_info_name[i];
      obj.icon = photo_info_icon[i];
      items.add(obj);
    }
    return items;
  }
}
